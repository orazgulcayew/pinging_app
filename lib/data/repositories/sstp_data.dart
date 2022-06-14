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
}
