import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'car_loan_model_v2.g.dart';

@HiveType(typeId: 13) // ← typeId ใหม่ (เดิม V1 ใช้ 11)
class CarLoanModelV2 extends Equatable {
  @HiveField(0)
  final double? carPrice;

  @HiveField(1)
  final double? downPayment;

  @HiveField(2)
  final double? interestRate;

  @HiveField(3)
  final String? loanTermYears; // V1: int? → V2: String?

  @HiveField(4)
  final double? monthlyPayment;

  @HiveField(5)
  final double? loanAmount;

  @HiveField(6)
  final double? totalInterest;

  @HiveField(7)
  final double? totalPayment;

  @HiveField(8)
  final DateTime? calculatedDate;

  const CarLoanModelV2({
    this.carPrice,
    this.downPayment,
    this.interestRate,
    this.loanTermYears,
    this.monthlyPayment,
    this.loanAmount,
    this.totalInterest,
    this.totalPayment,
    this.calculatedDate,
  });

  @override
  List<Object?> get props => [
    carPrice,
    downPayment,
    interestRate,
    loanTermYears,
    monthlyPayment,
    loanAmount,
    totalInterest,
    totalPayment,
    calculatedDate,
  ];
}
