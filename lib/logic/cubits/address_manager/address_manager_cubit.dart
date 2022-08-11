import 'dart:async';
import 'dart:convert';
import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:advertising_id/advertising_id.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:pinging/data/error/app_error.dart';
import 'package:pinging/data/models/sstp_data.dart';
import 'package:pinging/data/repositories/sstp_data.dart';
import 'package:pinging/logic/utils/pinging.dart';
import 'package:uuid/uuid.dart';

part 'address_manager_state.dart';

class AddressManagerCubit extends Cubit<AddressManagerState>
    with HydratedMixin {
  AddressManagerCubit() : super(AddressManagerInitial());

  bool _isWorking = false;

  void updateAuthKey(String authKey) {
    emit(state.copyWith(authKey: authKey));
  }

  Future<T> _oneProcessForMoment<T>(T defaultValue, Future<T> Function() f) {
    if (_isWorking) return Future.value(defaultValue);
    _isWorking = true;

    return f().then((value) {
      _isWorking = false;
      return value;
    });
  }

  String _createAndGetDeviceId() {
    if (state.deviceId == null) {
      String deviceId = const Uuid().v4();
      emit(state.copyWith(deviceId: deviceId));
      emit(state.copyWith(error: const DeviceIdAccessError()));
    }

    return state.deviceId!;
  }

  Future<String> _getId() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        return (await AdvertisingId.id(true))!;
      } else {
        return _createAndGetDeviceId();
      }
    } on PlatformException {
      return _createAndGetDeviceId();
    }
  }

  Future<bool> load() => _oneProcessForMoment<bool>(false, () async {
        try {
          emit(state.copyWith(pingingProgress: 0.01, isLoading: true));

          String deviceId = await _getId();

          var list = await SstpDataRepository().getSstpList4(
            authKey: state.authKey,
            deviceId: deviceId,
            onReceiveProgress: ((done, total) {
              if (total == -1) total = 30000;
              emit(state.copyWith(pingingProgress: (done + 0.01) / total));
            }),
          );

          emit(state.copyWith(addresses: list, isLoading: false));

          return true;
        } on DioError catch (err) {
          if (err.response != null && err.response!.statusCode == 500) {
            emit(
              state.copyWith(
                error: DioLoadError(
                  err.response!.data['error'],
                ),
                isLoading: false,
              ),
            );
          } else {
            emit(state.copyWith(error: const LoadError(), isLoading: false));
          }
        } catch (_) {
          emit(state.copyWith(error: const LoadError(), isLoading: false));
        }

        return false;
      });

  _onProgressPing(int all, int done, int pinging, int success) {
    emit(state.copyWith(pingingProgress: (done + 0.1) / all));
  }

  ping() => _oneProcessForMoment(true, () async {
        Pinging pinging = Pinging(timeout: const Duration(seconds: 2));

        final addresses = {...state.addresses, ...state.history}
            .map<PingingAddress>((e) => PingingAddress(e.ip, e.port))
            .toList();

        await pinging
            .bulkPing(
          addresses: addresses,
          onProgress: _onProgressPing,
        )
            .then(
          (addresses) {
            List<SstpDataModel> data = addresses
                .map((e) => SstpDataModel(ip: e.ip, port: e.port))
                .toList();

            var history = <SstpDataModel>{...state.history, ...data}.toList();

            emit(state.copyWith(
              addresses: data,
              history: history,
            ));
          },
        );
      });

  @override
  AddressManagerState? fromJson(Map<String, dynamic> json) {
    return AddressManagerState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(AddressManagerState state) {
    return state.toMap();
  }
}
