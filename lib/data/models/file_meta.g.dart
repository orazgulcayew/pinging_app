// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_meta.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SstpFileMetaAdapter extends TypeAdapter<SstpFileMeta> {
  @override
  final int typeId = 1;

  @override
  SstpFileMeta read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SstpFileMeta(
      name: fields[0] as String,
      sstpCount: fields[1] as int,
      byteSize: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SstpFileMeta obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.sstpCount)
      ..writeByte(2)
      ..write(obj.byteSize);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SstpFileMetaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
