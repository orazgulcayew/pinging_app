import 'package:pinging/data/models/sstp_data_response.dart';
import 'package:pinging/data/providers/sstp_data_api.dart';

class SstpDataRepository {
  Future<SstpDataResponse> getSstpList({
    void Function(int, int)? onReceiveProgress,
    required String authKey,
    required String deviceId,
    required int time,
  }) async {
    final data = await SstpDataApi().getAllHosts(
      onReceiveProgress: onReceiveProgress,
      authKey: authKey,
      deviceId: deviceId,
      time: time,
    );

    return SstpDataResponse.fromMap(data);
  }
}
