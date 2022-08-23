import 'package:flutter/foundation.dart' show immutable;
import 'sstp_data.dart';

@immutable
class SstpPingerResult {
  final bool success;
  final int ms;
  final SstpDataModel sstp;

  const SstpPingerResult(this.sstp, this.success, this.ms);
}
