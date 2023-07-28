// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borrow.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BorrowAdapter extends TypeAdapter<Borrow> {
  @override
  final int typeId = 2;

  @override
  Borrow read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Borrow()
      ..id = fields[0] as int
      ..userId = fields[1] as int
      ..bookId = fields[2] as int
      ..borrowDate = fields[3] as DateTime
      ..returnDate = fields[4] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Borrow obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.bookId)
      ..writeByte(3)
      ..write(obj.borrowDate)
      ..writeByte(4)
      ..write(obj.returnDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BorrowAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
