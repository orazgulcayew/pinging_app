// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SstpDataModel {
  final String ip;
  final int port;
  SstpDataModel({
    required this.ip,
    required this.port,
  });

  SstpDataModel copyWith({
    String? ip,
    int? port,
  }) {
    return SstpDataModel(
      ip: ip ?? this.ip,
      port: port ?? this.port,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ip': ip,
      'port': port,
    };
  }

  factory SstpDataModel.fromMap(Map<String, dynamic> map) {
    int port = 443;
    if (map['port'] is String) {
      port = int.parse(map['port']);
    } else {
      port = map['port'] as int;
    }

    return SstpDataModel(
      ip: map['ip'] as String,
      port: port,
    );
  }

  String toJson() => json.encode(toMap());

  factory SstpDataModel.fromJson(String source) =>
      SstpDataModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SstpDataModel(ip: $ip, port: $port)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SstpDataModel && other.ip == ip && other.port == port;
  }

  @override
  int get hashCode => ip.hashCode ^ port.hashCode;
}
