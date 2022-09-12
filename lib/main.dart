import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pinging/presentation/app.dart';
import 'package:pinging/presentation/router/app_router.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var dir = await getApplicationDocumentsDirectory();
  final storage = await HydratedStorage.build(
    storageDirectory: dir,
  );

  // Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAnalytics.instance;

  HydratedBlocOverrides.runZoned(
    () => runApp(
      App(
        appRouter: AppRouter(),
      ),
    ),
    storage: storage,
  );
}
