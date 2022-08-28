import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pinging/logic/cubits/address_manager/address_manager_cubit.dart';
import 'package:pinging/presentation/pages/home_page.dart';

class RegisterPage extends HookWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddressManagerCubit>();
    final controller = useTextEditingController(text: cubit.state.authKey);

    useEffect(() {
      if (cubit.state.authKey.isNotEmpty) {
        _onSubmitted(
          context: context,
          cubit: cubit,
          value: cubit.state.authKey,
        );
      }

      return;
    }, []);

    return SafeArea(
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
              cubit: cubit,
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
                cubit: cubit,
                value: controller.text,
              ),
              decoration: const InputDecoration(hintText: "Key"),
              controller: controller,
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmitted({
    required BuildContext context,
    required AddressManagerCubit cubit,
    required String value,
  }) {
    cubit.updateAuthKey(value);
    cubit.loadAll().then(
      (value) {
        if (!value) return;

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      },
    );
  }
}
