import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'retirement_model.g.dart';

@HiveType(typeId: 10)
class RetirementModel extends Equatable {
  @HiveField(0)
  final int? currentAge; // อายุปัจจุบัน

  @HiveField(1)
  final int? retirementAge; // อายุที่จะเกษียณ

  @HiveField(2)
  final double? currentSavings; // เงินเก็บเดิม

  @HiveField(3)
  final double? annualInterestRate; // ดอกเบี้ยรับต่อปี (%)

  @HiveField(4)
  final double? inflationRate; // เงินเฟ้อต่อปี (%)

  @HiveField(5)
  final int? lifeExpectancy; // คาดว่าจะมีอายุถึงกี่ปี

  @HiveField(6)
  final double? monthlyExpenses; // ค่าใช้จ่ายต่อเดือนที่จะใช้หลังเกษียณ (ปัจจุบัน)

  @HiveField(7)
  final int? yearsUntilRetirement; // ระยะเวลาก่อนเกษียณ (ปี)

  @HiveField(8)
  final int? yearsInRetirement; // ใช้เงินหลังเกษียณ (ปี)

  @HiveField(9)
  final double? currentMonthlyExpenses; // ค่าใช้จ่าย ณ ปัจจุบัน/เดือน

  @HiveField(10)
  final double? retirementMonthlyExpenses; // ค่าใช้จ่าย ณ วันเกษียณ/เดือน (รวมเงินเฟ้อ)

  @HiveField(11)
  final double? totalRetirementNeeded; // ต้องมีเงินเก็บ ณ วันเกษียณ

  @HiveField(12)
  final double? currentSavingsGrowth; // เงินเก็บเดิมโตเป็นเท่าไหร่ ณ วันเกษียณ

  @HiveField(13)
  final double? additionalSavingsNeeded; // ต้องเก็บเพิ่มอีกกี่บาท (รวม)

  @HiveField(14)
  final double? monthlySavingsNeeded; // ต้องเก็บเพิ่มอีกกี่บาทต่อเดือน

  @HiveField(15)
  final DateTime? calculatedDate;

  const RetirementModel({
    this.currentAge,
    this.retirementAge,
    this.currentSavings,
    this.annualInterestRate,
    this.inflationRate,
    this.lifeExpectancy,
    this.monthlyExpenses,
    this.yearsUntilRetirement,
    this.yearsInRetirement,
    this.currentMonthlyExpenses,
    this.retirementMonthlyExpenses,
    this.totalRetirementNeeded,
    this.currentSavingsGrowth,
    this.additionalSavingsNeeded,
    this.monthlySavingsNeeded,
    this.calculatedDate,
  });

  @override
  List<Object?> get props => [
        currentAge,
        retirementAge,
        currentSavings,
        annualInterestRate,
        inflationRate,
        lifeExpectancy,
        monthlyExpenses,
        yearsUntilRetirement,
        yearsInRetirement,
        currentMonthlyExpenses,
        retirementMonthlyExpenses,
        totalRetirementNeeded,
        currentSavingsGrowth,
        additionalSavingsNeeded,
        monthlySavingsNeeded,
        calculatedDate,
      ];

  RetirementModel copyWith({
    int? currentAge,
    int? retirementAge,
    double? currentSavings,
    double? annualInterestRate,
    double? inflationRate,
    int? lifeExpectancy,
    double? monthlyExpenses,
    int? yearsUntilRetirement,
    int? yearsInRetirement,
    double? currentMonthlyExpenses,
    double? retirementMonthlyExpenses,
    double? totalRetirementNeeded,
    double? currentSavingsGrowth,
    double? additionalSavingsNeeded,
    double? monthlySavingsNeeded,
    DateTime? calculatedDate,
  }) {
    return RetirementModel(
      currentAge: currentAge ?? this.currentAge,
      retirementAge: retirementAge ?? this.retirementAge,
      currentSavings: currentSavings ?? this.currentSavings,
      annualInterestRate: annualInterestRate ?? this.annualInterestRate,
      inflationRate: inflationRate ?? this.inflationRate,
      lifeExpectancy: lifeExpectancy ?? this.lifeExpectancy,
      monthlyExpenses: monthlyExpenses ?? this.monthlyExpenses,
      yearsUntilRetirement: yearsUntilRetirement ?? this.yearsUntilRetirement,
      yearsInRetirement: yearsInRetirement ?? this.yearsInRetirement,
      currentMonthlyExpenses: currentMonthlyExpenses ?? this.currentMonthlyExpenses,
      retirementMonthlyExpenses: retirementMonthlyExpenses ?? this.retirementMonthlyExpenses,
      totalRetirementNeeded: totalRetirementNeeded ?? this.totalRetirementNeeded,
      currentSavingsGrowth: currentSavingsGrowth ?? this.currentSavingsGrowth,
      additionalSavingsNeeded: additionalSavingsNeeded ?? this.additionalSavingsNeeded,
      monthlySavingsNeeded: monthlySavingsNeeded ?? this.monthlySavingsNeeded,
      calculatedDate: calculatedDate ?? this.calculatedDate,
    );
  }
}
