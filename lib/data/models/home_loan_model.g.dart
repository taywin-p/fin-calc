// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_loan_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HomeLoanModelAdapter extends TypeAdapter<HomeLoanModel> {
  @override
  final int typeId = 0;

  @override
  HomeLoanModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HomeLoanModel(
      housePrice: fields[0] as double?,
      downPayment: fields[1] as double?,
      interestRate: fields[2] as double?,
      loanTermYears: fields[3] as int?,
      monthlyPayment: fields[4] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, HomeLoanModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.housePrice)
      ..writeByte(1)
      ..write(obj.downPayment)
      ..writeByte(2)
      ..write(obj.interestRate)
      ..writeByte(3)
      ..write(obj.loanTermYears)
      ..writeByte(4)
      ..write(obj.monthlyPayment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeLoanModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
