import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinging/data/api/github_api.dart';
import 'package:pinging/data/error/app_error.dart';
import 'package:pinging/data/models/file_meta.dart';
import 'package:pinging/data/models/sstp_data.dart';
import 'package:pinging/data/repositories/github_repository.dart';
import 'package:pinging/data/storage/storage.dart';
import 'package:pinging/logic/blocs/app_error_bloc/app_error_bloc.dart';
import 'package:pinging/logic/blocs/loading_bloc/loading_bloc.dart';
import 'package:pinging/logic/utils/device_id.dart';
import 'package:pinging/logic/utils/sstp_pinger.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AppErrorBloc appErrorBloc;
  final LoadingBloc loadingBloc;

  Set<SstpDataModel> allSstps = {};

  AppBloc({
    required this.appErrorBloc,
    required this.loadingBloc,
  }) : super(AppInitial()) {
    on<AppEventLoad>((event, emit) {
      loadSstpsFromCache(emit);
    });

    on<AppEventToggleGhFile>((event, emit) async {
      final found = selectedFiles.any((e) => e == event.file.name);

      if (found) {
        selectedFiles =
            selectedFiles.where((e) => e != event.file.name).toList();
      } else {
        selectedFiles = [...selectedFiles, event.file.name];
      }

      await loadSstpsFromCache(emit);
      emit(AppStateSstpFileChecked(
        key: event.index,
        value: !found,
        // value: isFileSelected(event.file.name),
      ));
    });

    on<AppEventDeleteGhFile>((event, emit) async {
      final cached = Storage().sstpFiles;
      for (var key in cached.keys) {
        if (cached.get(key)!.name == event.file.name) {
          cached.delete(key);
        }
      }
      emit(AppStateFiles(event.files, cached.values));

      await loadSstpsFromCache(emit);
    });

    on<AppEventDownloadGhFile>((event, emit) async {
      await handleError(() async {
        final sstps = await GithubRepository().getSstpsByFileName(
          event.file.name,
          onReceiveProgress: (count, total) => emit(AppStateUniqueProgress(
            key: event.index,
            progress: ProgressStatus(count, event.file.byteSize),
          )),
        );

        emit(AppStateUniqueProgress(
          key: event.index,
          progress: ProgressStatus.done(),
        ));

        await Storage().lazyBox.put(
              event.file.name,
              jsonEncode(sstps.map((e) => e.toMap()).toList()),
            );
      });

      Storage().putSstpFile(event.file);
      emit(AppStateFiles(event.files, Storage().sstpFiles.values));

      await loadSstpsFromCache(emit);
    });

    on<AppEventLoadFiles>((event, emit) async {
      await handleError(() async {
        var files = await GithubRepository().getListOfFiles();
        emit(AppStateFiles(files, Storage().sstpFiles.values));

        final files2 = files.toList();

        for (int i = 0; i < files2.length; i++) {
          emit(AppStateSstpFileChecked(
            key: i,
            value: selectedFiles.any((e) => e == files2[i].name),
          ));
        }

        await loadSstpsFromCache(emit);
      });
    });

    on<AppEventAuth>((event, emit) async {
      loadingBloc.add(const StartLoadingEvent());

      await handleError(() async {
        deviceId = await DeviceIdGenerator().getDeviceId(deviceId);

        await GithubApi()
            .auth(authKey: event.authKey, deviceId: deviceId!)
            .loader();

        emit(AppStateUnlock());
      });

      loadingBloc.add(const StopLoadingEvent());

      await loadSstpsFromCache(emit);
    });

    on<AppEventPing>((event, emit) async {
      List<SstpDataModel> sstps = allSstps.toList();
      List<SstpDataModel> working = [];
      int chunkCount = 3;

      emit(AppStateInitialPingingProgress(chunkCount));

      BulkBulkSstpPinger pinger = BulkBulkSstpPinger(
        count: chunkCount,
        sstps: sstps.toList(),
        onPing: (sstpPinger, progress, index) {
          if (sstpPinger.success) {
            final sstp = sstpPinger.sstp.copyWith(ms: sstpPinger.ms);
            working.add(sstp);
            emit(AppStateSstps(working));
            emit(AppStateAppBarProgress(
              ProgressStatus(working.length, allSstps.length),
            ));
          }

          emit(AppStatePingingProgress(
            process: index,
            progress: progress,
          ));
        },
      );

      await pinger.start().then(
        (result) {
          List<SstpDataModel> working = result
              .where((e) => e.success)
              .map((e) => e.sstp.copyWith(ms: e.ms))
              .toList()
              .sortByPingTime();

          emit(AppStateSstps(working));
          emit(AppStateAppBarProgress(
            ProgressStatus(working.length, allSstps.length),
          ));
        },
      );
    });
  }

  loadSstpsFromCache(Emitter<AppState> emit) async {
    final files = selectedFiles;

    List<SstpDataModel> sstps = [];

    for (var filename in files) {
      if (!Storage().lazyBox.containsKey(filename)) {
        continue;
      }

      final raw = await Storage().lazyBox.get(filename);

      sstps.addAll(
        (jsonDecode(raw) as Iterable).map((e) => SstpDataModel.fromMap(e)),
      );
    }

    allSstps = sstps.toSet();
    emit(AppStateAppBarProgress(ProgressStatus(-1, allSstps.length)));
  }

  String? get deviceId {
    return Storage().settings.get("deviceId", defaultValue: null) as String?;
  }

  set deviceId(String? value) {
    Storage().settings.put("deviceId", value);
  }

  String get authKey {
    return Storage().settings.get("authKey", defaultValue: "") as String;
  }

  set authKey(String value) {
    Storage().settings.put("authKey", value);
  }

  int get lastRequestedTime {
    return Storage().settings.get("lastRequestedTime", defaultValue: 0) as int;
  }

  set lastRequestedTime(int value) {
    Storage().settings.put("lastRequestedTime", value);
  }

  List<String> get selectedFiles {
    return (Storage().settings.get("selectedFiles", defaultValue: []) as List)
        .map<String>((e) => e)
        .toList();
  }

  set selectedFiles(List<String> value) {
    Storage().settings.put("selectedFiles", value);
  }

  bool isFileSelected(String filename) {
    return selectedFiles.any((e) => e == filename);
  }

  FutureOr<void> handleError(FutureOr<void> Function() callback) async {
    try {
      await callback();
    } on AppError catch (err) {
      appErrorBloc.add(AppErrorAddEvent(err));
    } on DioError catch (err) {
      if (err.response != null && err.response!.statusCode == 500) {
        appErrorBloc.add(
          AppErrorAddEvent(
            DioLoadError(
              err.response!.data['error'],
            ),
          ),
        );
      } else {
        appErrorBloc.add(const AppErrorAddEvent(LoadError()));
      }
    } catch (_) {
      appErrorBloc.add(const AppErrorAddEvent(LoadError()));
    }
  }
}
