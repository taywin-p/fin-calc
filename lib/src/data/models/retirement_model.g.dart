// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retirement_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RetirementModelAdapter extends TypeAdapter<RetirementModel> {
  @override
  final int typeId = 10;

  @override
  RetirementModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RetirementModel(
      currentAge: fields[0] as int?,
      retirementAge: fields[1] as int?,
      currentSavings: fields[2] as double?,
      annualInterestRate: fields[3] as double?,
      inflationRate: fields[4] as double?,
      lifeExpectancy: fields[5] as int?,
      monthlyExpenses: fields[6] as double?,
      yearsUntilRetirement: fields[7] as int?,
      yearsInRetirement: fields[8] as int?,
      currentMonthlyExpenses: fields[9] as double?,
      retirementMonthlyExpenses: fields[10] as double?,
      totalRetirementNeeded: fields[11] as double?,
      currentSavingsGrowth: fields[12] as double?,
      additionalSavingsNeeded: fields[13] as double?,
      monthlySavingsNeeded: fields[14] as double?,
      calculatedDate: fields[15] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, RetirementModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.currentAge)
      ..writeByte(1)
      ..write(obj.retirementAge)
      ..writeByte(2)
      ..write(obj.currentSavings)
      ..writeByte(3)
      ..write(obj.annualInterestRate)
      ..writeByte(4)
      ..write(obj.inflationRate)
      ..writeByte(5)
      ..write(obj.lifeExpectancy)
      ..writeByte(6)
      ..write(obj.monthlyExpenses)
      ..writeByte(7)
      ..write(obj.yearsUntilRetirement)
      ..writeByte(8)
      ..write(obj.yearsInRetirement)
      ..writeByte(9)
      ..write(obj.currentMonthlyExpenses)
      ..writeByte(10)
      ..write(obj.retirementMonthlyExpenses)
      ..writeByte(11)
      ..write(obj.totalRetirementNeeded)
      ..writeByte(12)
      ..write(obj.currentSavingsGrowth)
      ..writeByte(13)
      ..write(obj.additionalSavingsNeeded)
      ..writeByte(14)
      ..write(obj.monthlySavingsNeeded)
      ..writeByte(15)
      ..write(obj.calculatedDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RetirementModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
