// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passwords_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PasswordModelAdapter extends TypeAdapter<PasswordModel> {
  @override
  final int typeId = 0;

  @override
  PasswordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PasswordModel(
      passwordId: fields[0] as String,
      passwordTitle: fields[1] as String,
      siteLink: fields[2] as String?,
      savedPassword: fields[3] as String,
      passwordDescription: fields[4] as String?,
      createdAt: fields[5] as DateTime?,
      modifiedAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PasswordModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.passwordId)
      ..writeByte(1)
      ..write(obj.passwordTitle)
      ..writeByte(2)
      ..write(obj.siteLink)
      ..writeByte(3)
      ..write(obj.savedPassword)
      ..writeByte(4)
      ..write(obj.passwordDescription)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.modifiedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PasswordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
