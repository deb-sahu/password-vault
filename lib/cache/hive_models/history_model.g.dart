// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoryModelAdapter extends TypeAdapter<HistoryModel> {
  @override
  final int typeId = 3;

  @override
  HistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryModel(
      historyId: fields[0] as String,
      passwordId: fields[1] as String,
      action: fields[2] as String,
      timestamp: fields[3] as DateTime,
      passwordTitle: fields[4] as String,
      siteLink: fields[5] as String,
      savedPassword: fields[6] as String,
      passwordDescription: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.historyId)
      ..writeByte(1)
      ..write(obj.passwordId)
      ..writeByte(2)
      ..write(obj.action)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.passwordTitle)
      ..writeByte(5)
      ..write(obj.siteLink)
      ..writeByte(6)
      ..write(obj.savedPassword)
      ..writeByte(7)
      ..write(obj.passwordDescription);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
