import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<String?> showInputDialog({
  required BuildContext context,
  required String? value,
}) {
  final controller = TextEditingController(text: value);
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text("Auth Key"),
        content: TextFormField(
          controller: controller,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(controller.text);
            },
            child: const Text("Set"),
          ),
        ],
      );
    },
  );
}
