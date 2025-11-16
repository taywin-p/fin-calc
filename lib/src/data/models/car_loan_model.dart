import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'car_loan_model.g.dart';

@HiveType(typeId: 11)
class CarLoanModel extends Equatable {
  @HiveField(0)
  final double? carPrice; // ราคารถ

  @HiveField(1)
  final double? downPayment; // เงินดาวน์

  @HiveField(2)
  final double? interestRate; // อัตราดอกเบี้ย (% ต่อปี)

  @HiveField(3)
  final int? loanTermYears; // ระยะเวลาผ่อน (ปี)

  @HiveField(4)
  final double? monthlyPayment; // ค่างวดต่อเดือน

  @HiveField(5)
  final double? loanAmount; // จำนวนเงินกู้

  @HiveField(6)
  final double? totalInterest; // ดอกเบี้ยรวม

  @HiveField(7)
  final double? totalPayment; // ยอดชำระรวมทั้งหมด

  @HiveField(8)
  final DateTime? calculatedDate;

  // V3Migration - เพิ่ม Field ใหม่
  @HiveField(9)
  final String? carModelName; // ชื่อรุ่นรถ (เช่น "Toyota Camry")

  const CarLoanModel({
    this.carPrice,
    this.downPayment,
    this.interestRate,
    this.loanTermYears,
    this.monthlyPayment,
    this.loanAmount,
    this.totalInterest,
    this.totalPayment,
    this.calculatedDate,
    this.carModelName, // V3Migration
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
    carModelName, // V3Migration
  ];

  CarLoanModel copyWith({
    double? carPrice,
    double? downPayment,
    double? interestRate,
    int? loanTermYears,
    double? monthlyPayment,
    double? loanAmount,
    double? totalInterest,
    double? totalPayment,
    DateTime? calculatedDate,
    String? carModelName, // V3Migration
  }) {
    return CarLoanModel(
      carPrice: carPrice ?? this.carPrice,
      downPayment: downPayment ?? this.downPayment,
      interestRate: interestRate ?? this.interestRate,
      loanTermYears: loanTermYears ?? this.loanTermYears,
      monthlyPayment: monthlyPayment ?? this.monthlyPayment,
      loanAmount: loanAmount ?? this.loanAmount,
      totalInterest: totalInterest ?? this.totalInterest,
      totalPayment: totalPayment ?? this.totalPayment,
      calculatedDate: calculatedDate ?? this.calculatedDate,
      carModelName: carModelName ?? this.carModelName, // V3Migration
    );
  }

  // For Hive UI compatibility
  Map<String, dynamic> toJson() {
    return {
      'carPrice': carPrice,
      'downPayment': downPayment,
      'interestRate': interestRate,
      'loanTermYears': loanTermYears,
      'monthlyPayment': monthlyPayment,
      'loanAmount': loanAmount,
      'totalInterest': totalInterest,
      'totalPayment': totalPayment,
      'calculatedDate': calculatedDate?.toIso8601String(),
      'carModelName': carModelName, // V3Migration
    };
  }
}

@HiveType(typeId: 12)
class CarLoanScheduleItem extends Equatable {
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

  const CarLoanScheduleItem({
    required this.month,
    required this.payment,
    required this.principal,
    required this.interest,
    required this.remainingBalance,
  });

  @override
  List<Object?> get props => [month, payment, principal, interest, remainingBalance];
}
