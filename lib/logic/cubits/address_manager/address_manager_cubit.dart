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
      var list = await SstpDataRepository().getSstpList2();
      emit(AddressManagerState(addresses: list));
    } catch (_) {
      // nothing
    }
  }

  void ping() {
    Pinging pinging = Pinging(timeout: const Duration(seconds: 2));

    pinging
        .bulkPing(
          addresses:
              state.addresses.map((e) => PingingAddress(e.ip, e.port)).toList(),
          onProgress: (int all, int done, int pinging, int success) => debugPrint(
              "all: $all   done: $done   pinging: $pinging   success: $success"),
        )
        .then(
          (addresses) => emit(
            state.copyWith(
              addresses: addresses
                  .map((e) => SstpDataModel(ip: e.ip, port: e.port))
                  .toList(),
            ),
          ),
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
