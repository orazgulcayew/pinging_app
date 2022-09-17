import 'dart:convert';
import 'package:hive/hive.dart';

part 'file_meta.g.dart';

@HiveType(typeId: 1)
class SstpFileMeta {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int sstpCount;

  @HiveField(2)
  final int byteSize;

  SstpFileMeta({
    required this.name,
    required this.sstpCount,
    required this.byteSize,
  });

  SstpFileMeta copyWith({
    String? name,
    int? sstpCount,
    int? byteSize,
  }) {
    return SstpFileMeta(
      name: name ?? this.name,
      sstpCount: sstpCount ?? this.sstpCount,
      byteSize: byteSize ?? this.byteSize,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'sstpCount': sstpCount,
      'byteSize': byteSize,
    };
  }

  factory SstpFileMeta.fromMap(Map<String, dynamic> map) {
    return SstpFileMeta(
      name: map['name'] as String,
      sstpCount: map['sstpCount'] as int,
      byteSize: map['byteSize'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SstpFileMeta.fromJson(String source) =>
      SstpFileMeta.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SstpFileMeta(name: $name, sstpCount: $sstpCount, byteSize: $byteSize)';

  @override
  bool operator ==(covariant SstpFileMeta other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.sstpCount == sstpCount &&
        other.byteSize == byteSize;
  }

  @override
  int get hashCode => name.hashCode ^ sstpCount.hashCode ^ byteSize.hashCode;
}
