// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_loan_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CarLoanModelAdapter extends TypeAdapter<CarLoanModel> {
  @override
  final int typeId = 11;

  @override
  CarLoanModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CarLoanModel(
      carPrice: fields[0] as double?,
      downPayment: fields[1] as double?,
      interestRate: fields[2] as double?,
      loanTermYears: fields[3] as int?,
      monthlyPayment: fields[4] as double?,
      loanAmount: fields[5] as double?,
      totalInterest: fields[6] as double?,
      totalPayment: fields[7] as double?,
      calculatedDate: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CarLoanModel obj) {
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
      other is CarLoanModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CarLoanScheduleItemAdapter extends TypeAdapter<CarLoanScheduleItem> {
  @override
  final int typeId = 12;

  @override
  CarLoanScheduleItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CarLoanScheduleItem(
      month: fields[0] as int,
      payment: fields[1] as double,
      principal: fields[2] as double,
      interest: fields[3] as double,
      remainingBalance: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, CarLoanScheduleItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.month)
      ..writeByte(1)
      ..write(obj.payment)
      ..writeByte(2)
      ..write(obj.principal)
      ..writeByte(3)
      ..write(obj.interest)
      ..writeByte(4)
      ..write(obj.remainingBalance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CarLoanScheduleItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
