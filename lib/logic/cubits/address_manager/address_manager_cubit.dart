import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:pinging/data/models/sstp_data.dart';
import 'package:pinging/data/repositories/sstp_data.dart';
import 'package:pinging/logic/utils/pinging.dart';

part 'address_manager_state.dart';

class AddressManagerCubit extends Cubit<AddressManagerState>
    with HydratedMixin {
  AddressManagerCubit() : super(AddressManagerInitial());

  void init() async {
    try {
      // var list = await SstpDataRepository().getSstpList2();
      emit(state.copyWith(pingingProgress: 0.1));

      var list = await SstpDataRepository().getSstpList3(
        onReceiveProgress: ((done, total) {
          debugPrint("$done - $total");
          emit(state.copyWith(pingingProgress: (done + 0.1) / total));
        }),
      );

      emit(state.copyWith(addresses: list));
    } catch (_) {
      // nothing
    }
  }

  _onProgressPing(int all, int done, int pinging, int success) {
    emit(state.copyWith(pingingProgress: (done + 0.1) / all));
  }

  void ping() {
    Pinging pinging = Pinging(timeout: const Duration(seconds: 2));

    final addresses = {...state.addresses, ...state.history}
        .map<PingingAddress>((e) => PingingAddress(e.ip, e.port))
        .toList();

    pinging
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
  }

  @override
  AddressManagerState? fromJson(Map<String, dynamic> json) {
    return AddressManagerState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(AddressManagerState state) {
    return state.toMap();
  }
}
