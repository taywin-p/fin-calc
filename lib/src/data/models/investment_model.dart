import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'investment_model.g.dart';

@HiveType(typeId: 6)
class InvestmentModel extends Equatable {
  @HiveField(0)
  final double? initialInvestment; // เงินลงทุนครั้งแรก

  @HiveField(1)
  final double? monthlyContribution; // เงินลงทุนรายเดือน

  @HiveField(2)
  final double? annualReturnRate; // อัตราผลตอบแทนต่อปี (%)

  @HiveField(3)
  final int? investmentYears; // ระยะเวลาการลงทุน (ปี)

  @HiveField(4)
  final InvestmentType? investmentType; // ประเภทการลงทุน

  @HiveField(6)
  final double? finalAmount; // จำนวนเงินสุดท้าย

  @HiveField(7)
  final double? totalContributions; // เงินลงทุนรวมทั้งหมด

  @HiveField(8)
  final double? totalReturns; // ผลตอบแทนรวม

  @HiveField(9)
  final DateTime? calculatedDate;

  const InvestmentModel({
    this.initialInvestment,
    this.monthlyContribution,
    this.annualReturnRate,
    this.investmentYears,
    this.investmentType,
    this.finalAmount,
    this.totalContributions,
    this.totalReturns,
    this.calculatedDate,
  });

  @override
  List<Object?> get props => [
    initialInvestment,
    monthlyContribution,
    annualReturnRate,
    investmentYears,
    investmentType,
    finalAmount,
    totalContributions,
    totalReturns,
    calculatedDate,
  ];

  InvestmentModel copyWith({
    double? initialInvestment,
    double? monthlyContribution,
    double? annualReturnRate,
    int? investmentYears,
    InvestmentType? investmentType,
    double? finalAmount,
    double? totalContributions,
    double? totalReturns,
    DateTime? calculatedDate,
  }) {
    return InvestmentModel(
      initialInvestment: initialInvestment ?? this.initialInvestment,
      monthlyContribution: monthlyContribution ?? this.monthlyContribution,
      annualReturnRate: annualReturnRate ?? this.annualReturnRate,
      investmentYears: investmentYears ?? this.investmentYears,
      investmentType: investmentType ?? this.investmentType,
      finalAmount: finalAmount ?? this.finalAmount,
      totalContributions: totalContributions ?? this.totalContributions,
      totalReturns: totalReturns ?? this.totalReturns,
      calculatedDate: calculatedDate ?? this.calculatedDate,
    );
  }
}

@HiveType(typeId: 7)
enum InvestmentType {
  @HiveField(0)
  conservative, // การลงทุนแบบอนุรักษ์นิยม (3-5% ต่อปี)

  @HiveField(1)
  balanced, // การลงทุนแบบสมดุล (5-8% ต่อปี)

  @HiveField(2)
  aggressive, // การลงทุนแบบเสี่ยง (8-12% ต่อปี)

  @HiveField(3)
  stock, // หุ้น (8-15% ต่อปี)

  @HiveField(4)
  bond, // พันธบัตร (2-5% ต่อปี)

  @HiveField(5)
  mutualFund, // กองทุนรวม (5-10% ต่อปี)

  @HiveField(6)
  etf, // ETF (6-10% ต่อปี)

  @HiveField(7)
  crypto, // สกุลเงินดิจิทัล (สูงมาก แต่เสี่ยงมาก)

  @HiveField(8)
  custom, // กำหนดเอง
}

@HiveType(typeId: 9)
class InvestmentScheduleItem extends Equatable {
  @HiveField(0)
  final int year;

  @HiveField(1)
  final double yearlyContribution; // เงินลงทุนในปีนั้น

  @HiveField(2)
  final double yearlyReturns; // ผลตอบแทนในปีนั้น

  @HiveField(3)
  final double totalValue; // มูลค่ารวมในปีนั้น

  @HiveField(4)
  final double totalContributed; // เงินลงทุนสะสมรวม

  @HiveField(5)
  final double cumulativeReturns; // ผลตอบแทนสะสมรวม

  const InvestmentScheduleItem({
    required this.year,
    required this.yearlyContribution,
    required this.yearlyReturns,
    required this.totalValue,
    required this.totalContributed,
    required this.cumulativeReturns,
  });

  @override
  List<Object?> get props => [year, yearlyContribution, yearlyReturns, totalValue, totalContributed, cumulativeReturns];
}

// Extension เพื่อแปลง enum เป็น string สำหรับ UI
extension InvestmentTypeExtension on InvestmentType {
  String get displayName {
    switch (this) {
      case InvestmentType.conservative:
        return 'อนุรักษ์นิยม (3-5%)';
      case InvestmentType.balanced:
        return 'สมดุล (5-8%)';
      case InvestmentType.aggressive:
        return 'เสี่ยงสูง (8-12%)';
      case InvestmentType.stock:
        return 'หุ้น (8-15%)';
      case InvestmentType.bond:
        return 'พันธบัตร (2-5%)';
      case InvestmentType.mutualFund:
        return 'กองทุนรวม (5-10%)';
      case InvestmentType.etf:
        return 'ETF (6-10%)';
      case InvestmentType.crypto:
        return 'คริปโต (สูงมาก)';
      case InvestmentType.custom:
        return 'กำหนดเอง';
    }
  }

  double get suggestedReturnRate {
    switch (this) {
      case InvestmentType.conservative:
        return 4.0;
      case InvestmentType.balanced:
        return 6.5;
      case InvestmentType.aggressive:
        return 10.0;
      case InvestmentType.stock:
        return 11.0;
      case InvestmentType.bond:
        return 3.5;
      case InvestmentType.mutualFund:
        return 7.5;
      case InvestmentType.etf:
        return 8.0;
      case InvestmentType.crypto:
        return 20.0;
      case InvestmentType.custom:
        return 8.0;
    }
  }
}
