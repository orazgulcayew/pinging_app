import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pinging/data/storage/storage.dart';
import 'package:pinging/presentation/app.dart';
import 'package:pinging/presentation/router/app_router.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // var dir = await getApplicationDocumentsDirectory();
  // final storage = await HydratedStorage.build(
  //   storageDirectory: dir,
  // );

  await Storage.init();

  if (Platform.isAndroid) {
    // Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseAnalytics.instance;
  }

  // HydratedBlocOverrides.runZoned(
  // () =>
  runApp(
    App(
      appRouter: AppRouter(),
    ),
    // ),
    // storage: storage,
  );
}
