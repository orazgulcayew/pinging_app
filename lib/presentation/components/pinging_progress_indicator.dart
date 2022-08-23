import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinging/logic/cubits/address_manager/address_manager_cubit.dart';

class PingingProgressIndicator extends StatelessWidget {
  const PingingProgressIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AddressManagerState>(
      stream: context.read<AddressManagerCubit>().stream,
      builder: (context, snapshot) {
        double value = 0;

        if (snapshot.hasData) {
          value = snapshot.data!.pingingProgress;
        }

        if (value == 0 || value == 1) return const SizedBox();

        return LinearProgressIndicator(
          minHeight: 10,
          value: value,
        );
      },
    );
  }
}
