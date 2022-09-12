import 'package:dio/dio.dart';

class SstpDataApi {
  Future<dynamic> getAllHosts({
    void Function(int, int)? onReceiveProgress,
    required String authKey,
    required String deviceId,
  }) async {
    var response = await Dio().get(
      "https://duralga-next-vercel.vercel.app/api/key_req",
      queryParameters: {
        "key": authKey,
        "deviceId": deviceId,
      },
      onReceiveProgress: onReceiveProgress,
    );

    return response.data;
  }

  Future<dynamic> getAllHosts2({
    void Function(int, int)? onReceiveProgress,
    required String authKey,
    required String deviceId,
    required DateTime time,
  }) async {
    var response = await Dio().get(
      "https://duralga-next-vercel.vercel.app/api/sstps",
      queryParameters: {
        "key": authKey,
        "deviceId": deviceId,
        "time": time,
      },
      onReceiveProgress: onReceiveProgress,
    );

    return response.data;
  }
}
