import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinging/logic/cubits/address_manager/address_manager_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => context.read<AddressManagerCubit>().init(),
            ),
            const SizedBox(height: 4),
            FloatingActionButton(
              child: const Icon(Icons.remove),
              onPressed: () => context.read<AddressManagerCubit>().ping(),
            ),
          ],
        ),
        body: Builder(builder: (context) {
          final addressManagerState =
              context.watch<AddressManagerCubit>().state;

          final iterable = addressManagerState.addresses.map(
            (e) => Card(
              child: ListTile(
                title: Text("${e.ip}:${e.port}"),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: "${e.ip}:${e.port}"));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(milliseconds: 300),
                      content: Text("${e.ip}:${e.port} copied to clipboard"),
                    ),
                  );
                },
              ),
            ),
          );

          return ListView(
            children: [
              Container(
                color: Colors.greenAccent,
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<AddressManagerState>(
                    stream: context.read<AddressManagerCubit>().stream,
                    builder: (context, snapshot) {
                      double value = 0;

                      if (snapshot.hasData) {
                        value = snapshot.data!.pingingProgress;
                      }

                      return LinearProgressIndicator(
                        minHeight: 10,
                        value: value,
                      );
                    }),
              ),
              ...iterable.toList(),
            ],
          );
        }),
      ),
    );
  }
}
