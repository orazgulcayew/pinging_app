import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pinging/logic/cubits/address_manager/address_manager_cubit.dart';
import 'package:pinging/presentation/components/cards/sstp_address_card.dart';
import 'package:pinging/presentation/components/pinging_progress_indicator.dart';
import 'package:pinging/presentation/pages/register_page.dart';

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController1 = useScrollController();
    // final scrollController2 = useScrollController();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.key_outlined),
              tooltip: 'Auth key',
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const RegisterPage(),
                ));
              },
            ),
          ],
          // bottom: PreferredSize(
          //   preferredSize: const Size.fromHeight(kTextTabBarHeight),
          //   child: Builder(builder: (context) {
          //     final history = context.read<AddressManagerCubit>().state.history;
          //     return Padding(
          //       padding: const EdgeInsets.all(16.0),
          //       child: Text("Total count: ${history.length}"),
          //     );
          //   }),
          // ),
          title: Builder(
            builder: (context) {
              final historyLength = context.select<AddressManagerCubit, int>(
                  (e) => e.state.history.length);

              return Text(
                "Polmuk ($historyLength)",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          // title: const Text("Pinging app for MS-SSTP servers"),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: kBottomNavigationBarHeight,
              child: Container(
                color: Theme.of(context).bottomAppBarColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () {
                          context.read<AddressManagerCubit>().loadAll();
                        },
                        color: Colors.white,
                        tooltip: "Get all",
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.upload),
                        onPressed: () {
                          context.read<AddressManagerCubit>().pingAll();
                        },
                        color: Colors.green,
                        tooltip: 'Ping all',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const PingingProgressIndicator(),
          ],
        ),
        body: _tabBarView1(scrollController1),
      ),
    );
  }

  // Builder _tabBarView2(ScrollController scrollController2) {
  //   return Builder(builder: (context) {
  //     var history = context.select<AddressManagerCubit, List<SstpDataModel>>(
  //         (value) => value.state.history);

  //     final sstps = history.toList();

  //     return Scrollbar(
  //       controller: scrollController2,
  //       child: ListView.builder(
  //         itemCount: sstps.length,
  //         itemBuilder: (context, index) {
  //           return SstpAddressCard(sstp: sstps[index]);
  //         },
  //         controller: scrollController2,
  //         shrinkWrap: true,
  //       ),
  //     );
  //   });
  // }

  Widget _tabBarView1(ScrollController scrollController1) {
    return BlocBuilder<AddressManagerCubit, AddressManagerState>(
      buildWhen: (previous, current) => previous.addresses != current.addresses,
      builder: (context, state) {
        final sstps = state.addresses;

        return Scrollbar(
          controller: scrollController1,
          child: ListView.builder(
            itemCount: sstps.length,
            itemBuilder: (context, index) {
              return SstpAddressCard(sstp: sstps[index]);
            },
            controller: scrollController1,
            shrinkWrap: true,
          ),
        );
      },
    );
  }
}
