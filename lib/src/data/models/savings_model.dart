import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'savings_model.g.dart';

@HiveType(typeId: 4)
class SavingsModel extends Equatable {
  @HiveField(0)
  final double? savingsGoal;

  @HiveField(1)
  final double? currentSavings;

  @HiveField(2)
  final double? monthlyDeposit;

  @HiveField(3)
  final double? interestRate; // ดอกเบี้ยเงินฝาก (ต่ำ 0.5-2%)

  @HiveField(4)
  final int? timeToGoalMonths; // เวลาที่ต้องใช้เพื่อถึงเป้าหมาย (เดือน)

  @HiveField(5)
  final double? finalAmount; // จำนวนเงินสุดท้าย

  @HiveField(6)
  final double? totalDeposits; // เงินฝากรวม

  @HiveField(7)
  final double? totalInterest; // ดอกเบี้ยรวม

  @HiveField(8)
  final DateTime? calculatedDate;

  @HiveField(9)
  final DateTime? goalAchievementDate; // วันที่จะถึงเป้าหมาย

  const SavingsModel({
    this.savingsGoal,
    this.currentSavings,
    this.monthlyDeposit,
    this.interestRate,
    this.timeToGoalMonths,
    this.finalAmount,
    this.totalDeposits,
    this.totalInterest,
    this.calculatedDate,
    this.goalAchievementDate,
  });

  @override
  List<Object?> get props => [
    savingsGoal,
    currentSavings,
    monthlyDeposit,
    interestRate,
    timeToGoalMonths,
    finalAmount,
    totalDeposits,
    totalInterest,
    calculatedDate,
    goalAchievementDate,
  ];

  SavingsModel copyWith({
    double? savingsGoal,
    double? currentSavings,
    double? monthlyDeposit,
    double? interestRate,
    int? timeToGoalMonths,
    double? finalAmount,
    double? totalDeposits,
    double? totalInterest,
    DateTime? calculatedDate,
    DateTime? goalAchievementDate,
  }) {
    return SavingsModel(
      savingsGoal: savingsGoal ?? this.savingsGoal,
      currentSavings: currentSavings ?? this.currentSavings,
      monthlyDeposit: monthlyDeposit ?? this.monthlyDeposit,
      interestRate: interestRate ?? this.interestRate,
      timeToGoalMonths: timeToGoalMonths ?? this.timeToGoalMonths,
      finalAmount: finalAmount ?? this.finalAmount,
      totalDeposits: totalDeposits ?? this.totalDeposits,
      totalInterest: totalInterest ?? this.totalInterest,
      calculatedDate: calculatedDate ?? this.calculatedDate,
      goalAchievementDate: goalAchievementDate ?? this.goalAchievementDate,
    );
  }
}

@HiveType(typeId: 5)
class SavingsScheduleItem extends Equatable {
  @HiveField(0)
  final int month;

  @HiveField(1)
  final double monthlyDeposit;

  @HiveField(2)
  final double interestEarned;

  @HiveField(3)
  final double balance;

  @HiveField(4)
  final double totalDeposited;

  const SavingsScheduleItem({
    required this.month,
    required this.monthlyDeposit,
    required this.interestEarned,
    required this.balance,
    required this.totalDeposited,
  });

  @override
  List<Object?> get props => [month, monthlyDeposit, interestEarned, balance, totalDeposited];
}
