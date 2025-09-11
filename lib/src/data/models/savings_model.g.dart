// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavingsModelAdapter extends TypeAdapter<SavingsModel> {
  @override
  final int typeId = 4;

  @override
  SavingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavingsModel(
      savingsGoal: fields[0] as double?,
      currentSavings: fields[1] as double?,
      monthlyDeposit: fields[2] as double?,
      interestRate: fields[3] as double?,
      timeToGoalMonths: fields[4] as int?,
      finalAmount: fields[5] as double?,
      totalDeposits: fields[6] as double?,
      totalInterest: fields[7] as double?,
      calculatedDate: fields[8] as DateTime?,
      goalAchievementDate: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SavingsModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.savingsGoal)
      ..writeByte(1)
      ..write(obj.currentSavings)
      ..writeByte(2)
      ..write(obj.monthlyDeposit)
      ..writeByte(3)
      ..write(obj.interestRate)
      ..writeByte(4)
      ..write(obj.timeToGoalMonths)
      ..writeByte(5)
      ..write(obj.finalAmount)
      ..writeByte(6)
      ..write(obj.totalDeposits)
      ..writeByte(7)
      ..write(obj.totalInterest)
      ..writeByte(8)
      ..write(obj.calculatedDate)
      ..writeByte(9)
      ..write(obj.goalAchievementDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SavingsScheduleItemAdapter extends TypeAdapter<SavingsScheduleItem> {
  @override
  final int typeId = 5;

  @override
  SavingsScheduleItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavingsScheduleItem(
      month: fields[0] as int,
      monthlyDeposit: fields[1] as double,
      interestEarned: fields[2] as double,
      balance: fields[3] as double,
      totalDeposited: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, SavingsScheduleItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.month)
      ..writeByte(1)
      ..write(obj.monthlyDeposit)
      ..writeByte(2)
      ..write(obj.interestEarned)
      ..writeByte(3)
      ..write(obj.balance)
      ..writeByte(4)
      ..write(obj.totalDeposited);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavingsScheduleItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
