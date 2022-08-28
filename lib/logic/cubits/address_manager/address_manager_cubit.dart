import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:pinging/data/error/app_error.dart';
import 'package:pinging/data/models/sstp_data.dart';
import 'package:pinging/data/repositories/sstp_data.dart';
import 'package:pinging/logic/utils/device_id.dart';
import 'package:pinging/logic/utils/sstp_pinger.dart';

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

  Future<bool> loadAll() => _oneProcessForMoment<bool>(false, () async {
        try {
          emit(state.copyWith(isLoading: true));

          String deviceId =
              await DeviceIdGenerator().getDeviceId(state.deviceId);

          var list = await SstpDataRepository().getSstpList(
            authKey: state.authKey,
            deviceId: deviceId,
          );

          emit(state.copyWith(
            addresses: {...state.addresses, ...list}.toList(),
            isLoading: false,
          ));

          return true;
        } on AppError catch (err) {
          emit(state.copyWith(error: err, isLoading: false));
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

  pingAll() => _oneProcessForMoment(true, () async {
        final sstps = {...state.addresses, ...state.history}.toList();

        BulkBulkSstpPinger pinger = BulkBulkSstpPinger(
          count: 10,
          sstps: sstps,
          onPing: (sstpPinger, progress) {
            emit(state.copyWith(pingingProgress: progress));
          },
        );

        await pinger.start().then(
          (result) {
            List<SstpDataModel> addresses = result
                .where((e) => e.success)
                .map((e) => e.sstp.copyWith(ms: e.ms))
                .toList()
                .sortByPingTime();

            var history = <SstpDataModel>{...state.history, ...addresses}
                .toList()
                .sortByPingTime();

            emit(state.copyWith(
              addresses: addresses,
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
