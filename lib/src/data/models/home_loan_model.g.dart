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
      loanAmount: fields[5] as double?,
      totalInterest: fields[6] as double?,
      totalPayment: fields[7] as double?,
      calculatedDate: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, HomeLoanModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.housePrice)
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
      other is HomeLoanModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PaymentScheduleItemAdapter extends TypeAdapter<PaymentScheduleItem> {
  @override
  final int typeId = 1;

  @override
  PaymentScheduleItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentScheduleItem(
      month: fields[0] as int,
      payment: fields[1] as double,
      principal: fields[2] as double,
      interest: fields[3] as double,
      remainingBalance: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, PaymentScheduleItem obj) {
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
      other is PaymentScheduleItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
