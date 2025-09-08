import 'package:equatable/equatable.dart'; 
import 'package:hive/hive.dart';

part 'home_loan_model.g.dart';

@HiveType(typeId: 0)
class HomeLoanModel extends Equatable { 
  @HiveField(0)
  final double? housePrice;

  @HiveField(1)
  final double? downPayment;

  @HiveField(2)
  final double? interestRate;

  @HiveField(3)
  final int? loanTermYears;

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

  const HomeLoanModel({ 
    this.housePrice,
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
        housePrice,
        downPayment,
        interestRate,
        loanTermYears,
        monthlyPayment,
        loanAmount,
        totalInterest,
        totalPayment,
        calculatedDate,
      ];

  HomeLoanModel copyWith({
    double? housePrice,
    double? downPayment,
    double? interestRate,
    int? loanTermYears,
    double? monthlyPayment,
    double? loanAmount,
    double? totalInterest,
    double? totalPayment,
    DateTime? calculatedDate,
  }) {
    return HomeLoanModel(
      housePrice: housePrice ?? this.housePrice,
      downPayment: downPayment ?? this.downPayment,
      interestRate: interestRate ?? this.interestRate,
      loanTermYears: loanTermYears ?? this.loanTermYears,
      monthlyPayment: monthlyPayment ?? this.monthlyPayment,
      loanAmount: loanAmount ?? this.loanAmount,
      totalInterest: totalInterest ?? this.totalInterest,
      totalPayment: totalPayment ?? this.totalPayment,
      calculatedDate: calculatedDate ?? this.calculatedDate,
    );
  }
}

@HiveType(typeId: 1)
class PaymentScheduleItem extends Equatable {
  @HiveField(0)
  final int month;

  @HiveField(1)
  final double payment;

  @HiveField(2)
  final double principal;

  @HiveField(3)
  final double interest;

  @HiveField(4)
  final double remainingBalance;

  const PaymentScheduleItem({
    required this.month,
    required this.payment,
    required this.principal,
    required this.interest,
    required this.remainingBalance,
  });

  @override
  List<Object?> get props => [month, payment, principal, interest, remainingBalance];
}