// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_model_home.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContactModelHomeAdapter extends TypeAdapter<ContactModelHome> {
  @override
  final int typeId = 0;

  @override
  ContactModelHome read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContactModelHome(
      uid: fields[0] as String,
      addedon: fields[1] as String,
      type: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ContactModelHome obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.addedon)
      ..writeByte(2)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactModelHomeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
