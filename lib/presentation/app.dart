import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinging/logic/blocs/app_bloc/app_bloc.dart';
import 'package:pinging/logic/blocs/app_error_bloc/app_error_bloc.dart';
import 'package:pinging/logic/blocs/loading_bloc/loading_bloc.dart';
import 'package:pinging/presentation/components/dialogs/show_app_error.dart';
import 'package:pinging/presentation/components/loading/loading_screen.dart';
import 'package:pinging/presentation/pages/home_page.dart';
import 'package:pinging/presentation/pages/register_page.dart';
import 'package:pinging/presentation/router/app_router.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  final AppRouter appRouter;

  const App({
    Key? key,
    required this.appRouter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appErrorBloc = AppErrorBloc();
    final loadingBloc = LoadingBloc();

    final appBloc =
        AppBloc(appErrorBloc: appErrorBloc, loadingBloc: loadingBloc);

    return MultiBlocProvider(
      providers: [
        BlocProvider<LoadingBloc>(create: (_) => loadingBloc),
        BlocProvider<AppErrorBloc>(create: (_) => appErrorBloc),
        BlocProvider<AppBloc>(create: (_) => appBloc),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'SSTPinger',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.green,
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.green,
                displayColor: Colors.green,
              ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.green,
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.green,
                displayColor: Colors.green,
              ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          /* dark theme settings */
        ),
        themeMode: ThemeMode.dark,
        // home: const RegisterPage(),
        home: const HomePage(),
        onGenerateRoute: appRouter.onGenerateRoute,
        builder: (context, child) => MultiBlocListener(
          listeners: [
            BlocListener<LoadingBloc, LoadState>(
              listener: (_, state) {
                if (state is LoadStateOn) {
                  LoadingScreen.instance().show(
                    navigatorKey: navigatorKey,
                    text: "Loading",
                  );
                } else {
                  LoadingScreen.instance().hide();
                }
              },
            ),
            BlocListener<AppErrorBloc, AppErrorState>(
              listener: (context, state) {
                if (state.error != null) {
                  final error = state.error!;

                  showAppError(
                    error: error,
                    context: navigatorKey.currentContext!,
                  ).then((value) {
                    context
                        .read<AppErrorBloc>()
                        .add(AppErrorRemoveEvent(error));
                  });
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
