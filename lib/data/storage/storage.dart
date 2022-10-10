import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:pinging/data/models/file_meta.dart';
import 'package:pinging/data/models/sstp_data.dart';

class Storage {
  factory Storage() => instance;

  static Storage instance = Storage._constructor();

  Storage._constructor() {
    lazyBox = Hive.lazyBox("lazyBox");
    sstpFiles = Hive.box<SstpFileMeta>("sstpFiles");
  }

  late LazyBox lazyBox;
  late Box<SstpFileMeta> sstpFiles;

  static init() async {
    Hive.registerAdapter(SstpFileMetaAdapter());

    await Hive.openLazyBox("lazyBox");
    await Hive.openBox<SstpFileMeta>("sstpFiles");
  }

  putSstpFile(SstpFileMeta file) {
    bool found = false;

    for (var key in sstpFiles.keys) {
      if (sstpFiles.get(key)!.name == file.name) {
        found = true;
        sstpFiles.put(key, file);
      }
    }

    if (!found) {
      sstpFiles.add(file);
    }
  }

  setWorkingSstps(List<SstpDataModel> sstps) =>
      lazyBox.put("workingSstps", jsonEncode(sstps.map((e) => e.toMap())));

  Future<List<SstpDataModel>> getWorikingSstps() async =>
      (jsonDecode(await lazyBox.get(
        "workingSstps",
        defaultValue: "[]",
      )) as List)
          .map<SstpDataModel>((e) => SstpDataModel.fromMap(e))
          .toList();
}
