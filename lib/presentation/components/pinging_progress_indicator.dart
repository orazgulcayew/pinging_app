import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinging/logic/blocs/app_bloc/app_bloc.dart';

class PingingProgressIndicator extends StatelessWidget {
  const PingingProgressIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const nothing = SizedBox();

    return BlocBuilder<AppBloc, AppState>(
      buildWhen: (_, state) => state is AppStateInitialPingingProgress,
      builder: (context, state) {
        int count = 0;

        if (state is AppStateInitialPingingProgress) count = state.chunkCount;

        return Row(
          children: List.generate(
            count,
            (index) => Expanded(
              child: BlocBuilder<AppBloc, AppState>(
                buildWhen: (_, state) =>
                    state is AppStatePingingProgress && state.process == index,
                builder: (context, state) {
                  if (state is! AppStatePingingProgress) return nothing;

                  final progress = state.progress;

                  if (progress.value == 0 || progress.value == 1) {
                    return nothing;
                  }

                  return LinearProgressIndicator(
                    color: Colors.green,
                    minHeight: 10,
                    value: progress.value,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
