import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pinging/data/models/sstp_data.dart';
import 'package:pinging/logic/cubits/address_manager/address_manager_cubit.dart';

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController1 = useScrollController();
    final scrollController2 = useScrollController();

    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.onetwothree_sharp)),
                Tab(icon: Icon(Icons.history_sharp)),
              ],
            ),
            title: const Text("Pinging app for MS-SSTP servers"),
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: kBottomNavigationBarHeight,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: IconButton(
                          icon: const Icon(Icons.download),
                          onPressed: () =>
                              context.read<AddressManagerCubit>().init(),
                          color: Colors.blue,
                          tooltip: "Get all",
                        ),
                      ),
                      const VerticalDivider(
                        thickness: 1,
                        width: 1,
                      ),
                      Expanded(
                        child: IconButton(
                          icon: const Icon(Icons.upload),
                          onPressed: () =>
                              context.read<AddressManagerCubit>().ping(),
                          color: Colors.green,
                          tooltip: 'Ping all',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              StreamBuilder<AddressManagerState>(
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
                  }),
            ],
          ),
          body: TabBarView(
            children: [
              Builder(
                builder: (context) {
                  var addresses =
                      context.select<AddressManagerCubit, List<SstpDataModel>>(
                          (value) => value.state.addresses);

                  final iterable = addresses.map<Widget>(
                    (e) => _createSstpCard(context, e),
                  );

                  return Scrollbar(
                    controller: scrollController1,
                    child: ListView(
                      controller: scrollController1,
                      shrinkWrap: true,
                      children: iterable.toList(),
                    ),
                  );
                },
              ),
              Builder(builder: (context) {
                var history =
                    context.select<AddressManagerCubit, List<SstpDataModel>>(
                        (value) => value.state.history);

                final iterable = history.map<Widget>(
                  (e) => _createSstpCard(context, e),
                );

                return Scrollbar(
                  controller: scrollController2,
                  child: ListView(
                    controller: scrollController2,
                    shrinkWrap: true,
                    children: iterable.toList(),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createSstpCard(BuildContext context, SstpDataModel e) {
    return Card(
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
    );
  }
}
