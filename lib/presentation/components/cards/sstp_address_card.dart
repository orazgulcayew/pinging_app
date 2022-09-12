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
          side: BorderSide(
            color: Colors.green,
            width: 1.5,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              sstp.location?.short ?? "--",
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              // Text(
              //   sstp.location?.short ?? "--",
              //   style: const TextStyle(color: Colors.green),
              // ),
              // const Text("  "),
              Expanded(
                child: Text(
                  sstp.info ?? ("- " * 10),
                  style: const TextStyle(fontSize: 11.0),
                  // overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        title: Text(
          "${sstp.ip}:${sstp.port}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Text(
          "${sstp.ms ?? "---"}ms",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
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
