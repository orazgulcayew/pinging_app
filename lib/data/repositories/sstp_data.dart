import 'dart:convert';

import 'package:pinging/data/models/sstp_data.dart';
import 'package:pinging/data/providers/sstp_data_api.dart';

class SstpDataRepository {
  Future<List<SstpDataModel>> getSstpList() async {
    final String rawSstpList = await SstpDataApi().getAllHosts();

    var parsed = jsonDecode(rawSstpList);

    return List.from(parsed)
        .map<SstpDataModel>((e) => SstpDataModel.fromMap(e))
        .toList();
  }

  Future<List<SstpDataModel>> getSstpList2() async {
    final String rawSstpList = await SstpDataApi().getAllHosts2();

    List<String> list = rawSstpList.split('\n');
    list.removeWhere((e) => e.trim().isEmpty);

    return list.map<SstpDataModel>((e) {
      var arr = e.split(':');
      return SstpDataModel(ip: arr[0], port: int.parse(arr[1]));
    }).toList();
  }

  Future<List<SstpDataModel>> getSstpList3({
    void Function(int, int)? onReceiveProgress,
  }) async {
    final String rawSstpList = await SstpDataApi().getAllHosts3(
      onReceiveProgress: onReceiveProgress,
    );

    List<String> list = rawSstpList.split('\n');
    list.removeWhere((e) => e.trim().isEmpty);

    return list.map<SstpDataModel>((e) {
      var arr = e.split(':');
      return SstpDataModel(ip: arr[0], port: int.parse(arr[1]));
    }).toList();
  }
}
