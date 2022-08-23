import 'dart:async';
import 'package:flutter/material.dart';

import 'loading_screen_controller.dart';

class LoadingScreen {
  LoadingScreen._sharedInstance();
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  factory LoadingScreen.instance() => _shared;

  LoadingScreenController? controller;

  void show({
    // required BuildContext context,
    required GlobalKey<NavigatorState> navigatorKey,
    required String text,
  }) {
    if (controller?.update(text) ?? false) {
      return;
    } else {
      controller = showOverlay(
        navigatorKey: navigatorKey,
        text: text,
      );
    }
  }

  void hide() {
    controller?.close();
    controller = null;
  }

  LoadingScreenController showOverlay({
    // required BuildContext context,
    required GlobalKey<NavigatorState> navigatorKey,
    required String text,
  }) {
    final controller = StreamController<String>();
    controller.add(text);

// access OverlayState
    // final OverlayState state = Overlay.of(context);
    final OverlayState? state = navigatorKey.currentState!.overlay;
    BuildContext context = navigatorKey.currentContext!;

    // final renderBox = context.findRenderObject() as RenderBox;
    // final size = renderBox.size;

    final size = MediaQuery.of(context).size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: _LoadingWidget(size: size, controller: controller),
          ),
        );
      },
    );

    state?.insert(overlay);

    return LoadingScreenController(
      close: () {
        controller.close();
        overlay.remove();
        return true;
      },
      update: (text) {
        controller.add(text);
        return true;
      },
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({
    Key? key,
    required this.size,
    required this.controller,
  }) : super(key: key);

  final Size size;
  final StreamController<String> controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      // constraints: BoxConstraints(
      //   maxWidth: size.width * 0.8,
      //   maxHeight: size.height * 0.8,
      //   minWidth: size.width * 0.5,
      // ),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 20),
              StreamBuilder(
                stream: controller.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data as String,
                      textAlign: TextAlign.center,
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
