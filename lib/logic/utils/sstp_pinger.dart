import 'dart:async';
import 'dart:io';
import 'package:pinging/data/models/sstp_data.dart';
import 'package:pinging/data/models/sstp_data_result.dart';

class SstpPinger {
  final Duration? timeout;
  final SstpDataModel sstp;

  SstpPinger(this.sstp, this.timeout);

  Future<SstpPingerResult> ping() async {
    final stopwatch = Stopwatch()..start();
    bool success = false;

    try {
      final socket = await Socket.connect(
        sstp.ip,
        sstp.port,
        timeout: timeout ?? timeout,
      );

      socket.destroy();

      success = true;
    } catch (_) {}

    return SstpPingerResult(sstp, success, stopwatch.elapsedMilliseconds);
  }
}

class BulkSstpPinger {
  final Duration? timeout;
  final List<SstpDataModel> sstps;
  final Function(SstpPingerResult sstpPinger)? onPing;
  int doneCount = 0;

  BulkSstpPinger({
    required this.sstps,
    this.onPing,
    this.timeout,
  });

  Future<List<SstpPingerResult>> pingAll() async {
    List<SstpPingerResult> result = [];

    for (var sstp in sstps) {
      final sstpPinger = await SstpPinger(sstp, timeout).ping();

      result.add(sstpPinger);

      onPing?.call(sstpPinger);

      doneCount++;
    }

    return result;
  }

  streamPingAll() async* {
    for (var sstp in sstps) {
      yield await SstpPinger(sstp, timeout).ping();
      doneCount++;
    }
  }
}

class BulkBulkSstpPinger {
  final int count;
  final Duration? timeout;
  final Function(SstpPingerResult sstpPinger, double progress)? onPing;
  final List<SstpDataModel> sstps;

  BulkBulkSstpPinger({
    required this.count,
    required this.sstps,
    this.timeout = const Duration(milliseconds: 9999),
    this.onPing,
  });

  int _done = 0;

  Future<List<SstpPingerResult>> start() async {
    List<List<SstpDataModel>> chunks = sstps.splitIntoChunks(5);

    List<Future<List<SstpPingerResult>>> futures = chunks
        .map((e) => BulkSstpPinger(
              sstps: e,
              timeout: timeout,
              onPing: (sstpPinger) {
                _done++;
                double progress = 0;
                if (sstps.isNotEmpty) {
                  progress = _done / sstps.length;
                }
                onPing?.call(sstpPinger, progress);
              },
            ).pingAll())
        .toList();

    final list = await Future.wait(futures);

    return list.joinChunks();
  }
}

extension SplitIntoChunks<T> on List<T> {
  List<List<T>> splitIntoChunks(int n) {
    int chunkSize = (length / n).ceil();
    List<List<T>> chunks = [];

    for (var i = 0; i < length; i += chunkSize) {
      chunks.add(sublist(
        i,
        i + chunkSize > length ? length : i + chunkSize,
      ));
    }

    return chunks;
  }
}

extension ChunksJoiner<T> on List<List<T>> {
  List<T> joinChunks() {
    List<T> result = [];

    for (var list in this) {
      result.addAll(list);
    }

    return result;
  }
}
