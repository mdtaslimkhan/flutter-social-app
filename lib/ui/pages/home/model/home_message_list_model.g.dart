// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_message_list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HomeMessageListAdapter extends TypeAdapter<HomeMessageList> {
  @override
  final int typeId = 0;

  @override
  HomeMessageList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HomeMessageList(
      message: fields[0] as String,
      time: fields[1] as String,
      id: fields[2] as String,
      name: fields[3] as String,
      photo: fields[4] as String,
      contactId: fields[5] as String,
      type: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HomeMessageList obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.message)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.photo)
      ..writeByte(5)
      ..write(obj.contactId)
      ..writeByte(6)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeMessageListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
