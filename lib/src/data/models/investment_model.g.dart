// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investment_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InvestmentModelAdapter extends TypeAdapter<InvestmentModel> {
  @override
  final int typeId = 6;

  @override
  InvestmentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InvestmentModel(
      initialInvestment: fields[0] as double?,
      monthlyContribution: fields[1] as double?,
      annualReturnRate: fields[2] as double?,
      investmentYears: fields[3] as int?,
      investmentType: fields[4] as InvestmentType?,
      finalAmount: fields[6] as double?,
      totalContributions: fields[7] as double?,
      totalReturns: fields[8] as double?,
      calculatedDate: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, InvestmentModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.initialInvestment)
      ..writeByte(1)
      ..write(obj.monthlyContribution)
      ..writeByte(2)
      ..write(obj.annualReturnRate)
      ..writeByte(3)
      ..write(obj.investmentYears)
      ..writeByte(4)
      ..write(obj.investmentType)
      ..writeByte(6)
      ..write(obj.finalAmount)
      ..writeByte(7)
      ..write(obj.totalContributions)
      ..writeByte(8)
      ..write(obj.totalReturns)
      ..writeByte(9)
      ..write(obj.calculatedDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvestmentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InvestmentScheduleItemAdapter
    extends TypeAdapter<InvestmentScheduleItem> {
  @override
  final int typeId = 9;

  @override
  InvestmentScheduleItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InvestmentScheduleItem(
      year: fields[0] as int,
      yearlyContribution: fields[1] as double,
      yearlyReturns: fields[2] as double,
      totalValue: fields[3] as double,
      totalContributed: fields[4] as double,
      cumulativeReturns: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, InvestmentScheduleItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.year)
      ..writeByte(1)
      ..write(obj.yearlyContribution)
      ..writeByte(2)
      ..write(obj.yearlyReturns)
      ..writeByte(3)
      ..write(obj.totalValue)
      ..writeByte(4)
      ..write(obj.totalContributed)
      ..writeByte(5)
      ..write(obj.cumulativeReturns);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvestmentScheduleItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InvestmentTypeAdapter extends TypeAdapter<InvestmentType> {
  @override
  final int typeId = 7;

  @override
  InvestmentType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return InvestmentType.conservative;
      case 1:
        return InvestmentType.balanced;
      case 2:
        return InvestmentType.aggressive;
      case 3:
        return InvestmentType.stock;
      case 4:
        return InvestmentType.bond;
      case 5:
        return InvestmentType.mutualFund;
      case 6:
        return InvestmentType.etf;
      case 7:
        return InvestmentType.crypto;
      case 8:
        return InvestmentType.custom;
      default:
        return InvestmentType.conservative;
    }
  }

  @override
  void write(BinaryWriter writer, InvestmentType obj) {
    switch (obj) {
      case InvestmentType.conservative:
        writer.writeByte(0);
        break;
      case InvestmentType.balanced:
        writer.writeByte(1);
        break;
      case InvestmentType.aggressive:
        writer.writeByte(2);
        break;
      case InvestmentType.stock:
        writer.writeByte(3);
        break;
      case InvestmentType.bond:
        writer.writeByte(4);
        break;
      case InvestmentType.mutualFund:
        writer.writeByte(5);
        break;
      case InvestmentType.etf:
        writer.writeByte(6);
        break;
      case InvestmentType.crypto:
        writer.writeByte(7);
        break;
      case InvestmentType.custom:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvestmentTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
