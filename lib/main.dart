import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pinging/logic/cubits/address_manager/address_manager_cubit.dart';
import 'package:pinging/presentation/components/dialogs/show_load_error.dart';
import 'package:pinging/presentation/components/loading/loading_screen.dart';
import 'package:pinging/presentation/pages/register_page.dart';
import 'package:pinging/presentation/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var dir = await getApplicationDocumentsDirectory();
  final storage = await HydratedStorage.build(
    storageDirectory: dir,
  );

  HydratedBlocOverrides.runZoned(
    () => runApp(
      MyApp(
        appRouter: AppRouter(),
      ),
    ),
    storage: storage,
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({
    Key? key,
    required this.appRouter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddressManagerCubit>(
          create: (_) => AddressManagerCubit(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'SSTPinger',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const RegisterPage(),
        onGenerateRoute: appRouter.onGenerateRoute,
        builder: (context, child) => MultiBlocListener(
          listeners: [
            BlocListener<AddressManagerCubit, AddressManagerState>(
              listenWhen: (previous, current) =>
                  previous.error != current.error,
              listener: (context, state) {
                if (state.error != null) {
                  showLoadError(
                    error: state.error!,
                    context: navigatorKey.currentContext!,
                  );
                }
              },
            ),
            BlocListener<AddressManagerCubit, AddressManagerState>(
              listener: (context, state) {
                if (state.isLoading) {
                  LoadingScreen.instance().show(
                    navigatorKey: navigatorKey,
                    text: "Loading",
                  );
                } else {
                  LoadingScreen.instance().hide();
                }
              },
            ),
          ],
          child: child!,
        ),
      ),
    );
  }
}
