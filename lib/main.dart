import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pinging/presentation/app.dart';
import 'package:pinging/presentation/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var dir = await getApplicationDocumentsDirectory();
  final storage = await HydratedStorage.build(
    storageDirectory: dir,
  );

  HydratedBlocOverrides.runZoned(
    () => runApp(
      App(
        appRouter: AppRouter(),
      ),
    ),
    storage: storage,
  );
}
