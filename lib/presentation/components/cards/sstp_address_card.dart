import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinging/data/models/sstp_data.dart';

class SstpAddressCard extends StatelessWidget {
  final SstpDataModel sstp;
  const SstpAddressCard({Key? key, required this.sstp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        shape: const BeveledRectangleBorder(
          side: BorderSide(color: Colors.green),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              sstp.location?.short ?? "--",
              style: const TextStyle(color: Colors.green),
            ),
            const Text("  "),
            Text(sstp.hostname ?? ("- " * 10)),
          ],
        ),
        title: Text("${sstp.ip}:${sstp.port}"),
        trailing: Text("${sstp.ms ?? "---"}ms"),
        onTap: () {
          Clipboard.setData(ClipboardData(text: "${sstp.ip}:${sstp.port}"));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(milliseconds: 300),
              content: Text("${sstp.ip}:${sstp.port} copied to clipboard"),
            ),
          );
        },
      ),
    );
  }
}
