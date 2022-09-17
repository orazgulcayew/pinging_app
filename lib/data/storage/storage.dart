import 'package:hive_flutter/hive_flutter.dart';
import 'package:pinging/data/models/file_meta.dart';

class Storage {
  factory Storage() => instance;

  static Storage instance = Storage._constructor();

  Storage._constructor() {
    settings = Hive.box("settings");
    lazyBox = Hive.lazyBox("lazyBox");
    sstpFiles = Hive.box<SstpFileMeta>("sstpFiles");
  }

  late Box settings;
  late LazyBox lazyBox;
  late Box<SstpFileMeta> sstpFiles;

  static init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(SstpFileMetaAdapter());

    await Hive.openBox("settings");
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
}
