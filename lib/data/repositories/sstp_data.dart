import 'package:pinging/data/models/sstp_data.dart';
import 'package:pinging/data/providers/sstp_data_api.dart';

class SstpDataRepository {
  Future<List<SstpDataModel>> getSstpList({
    void Function(int, int)? onReceiveProgress,
    required String authKey,
    required String deviceId,
  }) async {
    final data = await SstpDataApi().getAllHosts(
      onReceiveProgress: onReceiveProgress,
      authKey: authKey,
      deviceId: deviceId,
    );

    return (data as List)
        .map<SstpDataModel>((e) => SstpDataModel.fromMap(e))
        .toList();
  }

  Future<List<SstpDataModel>> getSstpList2({
    void Function(int, int)? onReceiveProgress,
    required String authKey,
    required String deviceId,
    required DateTime time,
  }) async {
    final data = await SstpDataApi().getAllHosts2(
      onReceiveProgress: onReceiveProgress,
      authKey: authKey,
      deviceId: deviceId,
      time: time,
    );

    return (data as List)
        .map<SstpDataModel>((e) => SstpDataModel.fromMap(e))
        .toList();
  }
}
