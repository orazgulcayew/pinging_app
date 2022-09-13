// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:pinging/data/models/sstp_data.dart';

class SstpDataResponse {
  final int time;
  final List<SstpDataModel> sstps;

  SstpDataResponse({
    required this.time,
    required this.sstps,
  });

  SstpDataResponse copyWith({
    int? time,
    List<SstpDataModel>? sstps,
  }) {
    return SstpDataResponse(
      time: time ?? this.time,
      sstps: sstps ?? this.sstps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'time': time,
      'sstps': sstps.map((x) => x.toMap()).toList(),
    };
  }

  factory SstpDataResponse.fromMap(Map<String, dynamic> map) {
    return SstpDataResponse(
      time: map['time'] as int,
      sstps: List<SstpDataModel>.from(
        (map['sstps'] as List<dynamic>).map<SstpDataModel>(
          (x) => SstpDataModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory SstpDataResponse.fromJson(String source) =>
      SstpDataResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SstpDataResponse(time: $time, sstps: $sstps)';

  @override
  bool operator ==(covariant SstpDataResponse other) {
    if (identical(this, other)) return true;

    return other.time == time && listEquals(other.sstps, sstps);
  }

  @override
  int get hashCode => time.hashCode ^ sstps.hashCode;
}
