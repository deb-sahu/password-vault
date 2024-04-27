// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_preferences_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SystemPreferencesModelAdapter
    extends TypeAdapter<SystemPreferencesModel> {
  @override
  final int typeId = 2;

  @override
  SystemPreferencesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SystemPreferencesModel(
      id: fields[0] as int,
      isDarkMode: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SystemPreferencesModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.isDarkMode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SystemPreferencesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
