// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_loan_model_v2.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CarLoanModelV2Adapter extends TypeAdapter<CarLoanModelV2> {
  @override
  final int typeId = 13;

  @override
  CarLoanModelV2 read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CarLoanModelV2(
      carPrice: fields[0] as double?,
      downPayment: fields[1] as double?,
      interestRate: fields[2] as double?,
      loanTermYears: fields[3] as String?,
      monthlyPayment: fields[4] as double?,
      loanAmount: fields[5] as double?,
      totalInterest: fields[6] as double?,
      totalPayment: fields[7] as double?,
      calculatedDate: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CarLoanModelV2 obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.carPrice)
      ..writeByte(1)
      ..write(obj.downPayment)
      ..writeByte(2)
      ..write(obj.interestRate)
      ..writeByte(3)
      ..write(obj.loanTermYears)
      ..writeByte(4)
      ..write(obj.monthlyPayment)
      ..writeByte(5)
      ..write(obj.loanAmount)
      ..writeByte(6)
      ..write(obj.totalInterest)
      ..writeByte(7)
      ..write(obj.totalPayment)
      ..writeByte(8)
      ..write(obj.calculatedDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CarLoanModelV2Adapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
