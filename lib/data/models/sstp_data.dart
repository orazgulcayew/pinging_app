// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SstpDataModel {
  final String ip;
  final int port;
  final int? ms;
  final String? hostname;
  final LocationModel? location;

  SstpDataModel({
    required this.ip,
    required this.port,
    this.ms,
    this.hostname,
    this.location,
  });

  SstpDataModel copyWith({
    String? ip,
    int? port,
    int? ms,
    String? hostname,
    LocationModel? location,
  }) {
    return SstpDataModel(
      ip: ip ?? this.ip,
      port: port ?? this.port,
      ms: ms ?? this.ms,
      hostname: hostname ?? this.hostname,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ip': ip,
      'port': port,
      'ms': ms,
      'hostname': hostname,
      'location': location?.toMap(),
    };
  }

  factory SstpDataModel.fromMap(Map<String, dynamic> map) {
    return SstpDataModel(
      ip: map['ip'] as String,
      port: map['port'] as int,
      ms: map['ms'] != null ? map['ms'] as int : null,
      hostname: map['hostname'] != null ? map['hostname'] as String : null,
      location: map['location'] != null
          ? LocationModel.fromMap(map['location'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SstpDataModel.fromJson(String source) =>
      SstpDataModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SstpDataModel(ip: $ip, port: $port, ms: $ms, hostname: $hostname, location: $location)';
  }

  @override
  bool operator ==(covariant SstpDataModel other) {
    if (identical(this, other)) return true;

    return other.ip == ip && other.port == port;
  }

  @override
  int get hashCode {
    return ip.hashCode ^ port.hashCode;
  }
}

class LocationModel {
  final String country;
  final String short;
  final String name;

  LocationModel({
    required this.country,
    required this.short,
    required this.name,
  });

  LocationModel copyWith({
    String? country,
    String? short,
    String? name,
  }) {
    return LocationModel(
      country: country ?? this.country,
      short: short ?? this.short,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'country': country,
      'short': short,
      'name': name,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      country: map['country'] as String,
      short: map['short'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationModel.fromJson(String source) =>
      LocationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'LocationModel(country: $country, short: $short, name: $name)';

  @override
  bool operator ==(covariant LocationModel other) {
    if (identical(this, other)) return true;

    return other.country == country &&
        other.short == short &&
        other.name == name;
  }

  @override
  int get hashCode => country.hashCode ^ short.hashCode ^ name.hashCode;
}
