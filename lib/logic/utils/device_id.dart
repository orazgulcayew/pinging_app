import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class DeviceIdGenerator {
  String _createAndGetDeviceId(String? deviceId) {
    if (deviceId == null) {
      return const Uuid().v4();

      // emit(state.copyWith(deviceId: deviceId));
      // emit(state.copyWith(error: const DeviceIdAccessError()));
      // throw const DeviceIdAccessError();
    }

    return deviceId;
  }

  /// * oldDeviceId param1
  Future<String> getDeviceId(String? deviceId) async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        return (await AdvertisingId.id(true))!;
      } else {
        return _createAndGetDeviceId(deviceId);
      }
    } on PlatformException {
      return _createAndGetDeviceId(deviceId);
    }
  }
}
