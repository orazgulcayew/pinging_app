import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pinging/data/storage/storage.dart';
import 'package:pinging/logic/blocs/app_bloc/app_bloc.dart';
import 'package:pinging/logic/utils/sstp_pinger.dart';
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
          title: BlocBuilder<AppBloc, AppState>(
            buildWhen: (_, state) => state is AppStateAppBarProgress,
            builder: (context, state) {
              String text = "Pinging App ";

              if (state is AppStateAppBarProgress) {
                text += "${state.progress.count}/${state.progress.total}";
              }

              return Text(
                text,
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
                          selectFiles(context);
                        },
                        color: Colors.white,
                        tooltip: "Get all",
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.upload),
                        onPressed: () {
                          context.read<AppBloc>().add(AppEventPing());
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
        body: buildBody(scrollController1),
      ),
    );
  }

  Widget buildBody(ScrollController scrollController1) {
    return BlocBuilder<AppBloc, AppState>(
      buildWhen: (_, state) => state is AppStateSstps,
      builder: (context, state) {
        if (state is! AppStateSstps) return const SizedBox();

        final sstps = state.sstps.toList();

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

  selectFiles(BuildContext context) {
    final bloc = context.read<AppBloc>();

    bloc.add(AppEventLoadFiles());

    return showDialog<String>(
      context: context,
      builder: (context) {
        return BlocBuilder<AppBloc, AppState>(
          buildWhen: (_, state) => state is AppStateFiles,
          builder: (context, state) {
            Widget child = const Center(child: CircularProgressIndicator());

            if (state is AppStateFiles) {
              final files = state.files.toList();
              final cached = state.cached.toList();

              child = ListView.builder(
                shrinkWrap: true,
                itemCount: files.length,
                itemBuilder: (context, index) {
                  final file = files[index];

                  Icon icon = const Icon(
                    Icons.download_rounded,
                    color: Colors.green,
                  );

                  if (cached.any((e) => e.name == file.name)) {
                    icon = const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                    );

                    final cachedFile =
                        cached.firstWhere((e) => e.name == file.name);

                    if (file.byteSize != cachedFile.byteSize) {
                      icon = const Icon(
                        Icons.refresh_rounded,
                        color: Colors.green,
                      );
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Material(
                      elevation: 5,
                      child: BlocBuilder<AppBloc, AppState>(
                        buildWhen: (_, state) =>
                            state is AppStateSstpFileChecked &&
                            state.key == index,
                        builder: (context, state) {
                          bool checked = bloc.isFileSelected(file.name);

                          // if (state is AppStateSstpFileChecked) {
                          //   checked = state.value;
                          // }

                          return CheckboxListTile(
                            value: checked,
                            onChanged: (_) {
                              bloc.add(AppEventToggleGhFile(files, index));
                            },
                            title: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                "${file.name} - ${file.sstpCount}",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                            // secondary:
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BlocBuilder<AppBloc, AppState>(
                                  buildWhen: (_, state) =>
                                      state is AppStateUniqueProgress &&
                                      state.key == index,
                                  builder: (context, state) {
                                    double value = 0;
                                    ProgressStatus? progress;
                                    String text = "Empty";

                                    if (Storage().sstpFiles.values.any(
                                        (e) => e.name == files[index].name)) {
                                      value = 1;
                                      text = "Done";
                                    }

                                    if (state is AppStateUniqueProgress) {
                                      progress = state.progress;

                                      if (progress.total != 0) {
                                        value = progress.count / progress.total;
                                      }

                                      text =
                                          "${progress.count}/${progress.total}";

                                      if (progress.done) {
                                        text = "Done";
                                      }
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4.0,
                                      ),
                                      child: Stack(
                                        children: [
                                          LinearProgressIndicator(
                                            color: Colors.green,
                                            value: value,
                                            minHeight: 15,
                                          ),
                                          Center(
                                            child: Text(
                                              text,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        bloc.add(
                                          AppEventDeleteGhFile(files, index),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.delete_rounded,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    IconButton(
                                      onPressed: () {
                                        bloc.add(
                                          AppEventDownloadGhFile(files, index),
                                        );
                                      },
                                      icon: icon,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            }
            final size = MediaQuery.of(context).size;
            return AlertDialog(
              title: const Text("Search from files:"),
              content: SizedBox(
                width: size.width > 400 ? 400 : size.width,
                child: child,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Ok"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
