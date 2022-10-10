import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pinging/data/storage/settings.dart';
import 'package:pinging/logic/blocs/app_bloc/app_bloc.dart';
import 'package:pinging/presentation/pages/home_page.dart';

class RegisterPage extends HookWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AppBloc>();
    final authKey = Settings().authKey;
    final controller = useTextEditingController(text: authKey);

    useEffect(() {
      if (authKey.isNotEmpty) {
        _onSubmitted(
          context: context,
          bloc: bloc,
          value: Settings().authKey,
        );
      }

      return;
    }, []);

    return BlocListener<AppBloc, AppState>(
      listenWhen: (_, state) => state is AppStateUnlock,
      listener: (context, state) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Auth Key"),
          ),
          bottomNavigationBar: SizedBox(
            height: kBottomNavigationBarHeight,
            child: ElevatedButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                ),
              ),
              child: const Text("Try"),
              onPressed: () => _onSubmitted(
                context: context,
                bloc: bloc,
                value: controller.text,
              ),
            ),
          ),
          body: Center(
            child: SizedBox(
              width: 250,
              child: TextFormField(
                onFieldSubmitted: (value) => _onSubmitted(
                  context: context,
                  bloc: bloc,
                  value: controller.text,
                ),
                decoration: const InputDecoration(hintText: "Key"),
                controller: controller,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmitted({
    required BuildContext context,
    required AppBloc bloc,
    required String value,
  }) {
    Settings().authKey = value;
    bloc.add(AppEventAuth(value));
  }
}
