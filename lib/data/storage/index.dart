import 'package:hive_flutter/hive_flutter.dart';
import 'package:pinging/data/storage/settings.dart';
import 'package:pinging/data/storage/storage.dart';

Future<void> initStorage() async {
  await Hive.initFlutter();

  await Storage.init();
  await Settings.init();
}
