import 'dart:math';
import '../models/car_loan_model.dart';

class CarLoanCalculatorService {
  /// คำนวณสินเชื่อรถยนต์แบบดอกเบี้ยคงที่ (Flat Rate)
  static CarLoanModel calculateCarLoan({
    required double carPrice,
    required double downPayment,
    required double interestRate,
    required int loanTermYears,
  }) {
    final loanAmount = carPrice - downPayment;
    final numberOfPayments = loanTermYears * 12;

    // คำนวณดอกเบี้ยทั้งหมดแบบคงที่
    final totalInterest = loanAmount * (interestRate / 100) * loanTermYears;
    
    // ยอดชำระรวมทั้งหมด
    final totalPayment = loanAmount + totalInterest;
    
    // ค่าผ่อนรายเดือน (เท่ากันทุกเดือน)
    final monthlyPayment = totalPayment / numberOfPayments;

    return CarLoanModel(
      carPrice: carPrice,
      downPayment: downPayment,
      interestRate: interestRate,
      loanTermYears: loanTermYears,
      monthlyPayment: monthlyPayment,
      loanAmount: loanAmount,
      totalInterest: totalInterest,
      totalPayment: totalPayment,
      calculatedDate: DateTime.now(),
    );
  }

  /// สร้างตารางการผ่อนชำระรายเดือนแบบดอกเบี้ยคงที่
  static List<CarLoanScheduleItem> generatePaymentSchedule({
    required double loanAmount,
    required double monthlyPayment,
    required double interestRate,
    required int numberOfPayments,
  }) {
    List<CarLoanScheduleItem> schedule = [];
    
    // คำนวณดอกเบี้ยรายเดือน (แบบคงที่)
    final totalInterest = loanAmount * (interestRate / 100) * (numberOfPayments / 12);
    final monthlyInterest = totalInterest / numberOfPayments;
    final monthlyPrincipal = (loanAmount / numberOfPayments);
    
    double remainingBalance = loanAmount;

    for (int month = 1; month <= numberOfPayments; month++) {
      remainingBalance -= monthlyPrincipal;

      if (remainingBalance < 0) {
        remainingBalance = 0;
      }

      schedule.add(
        CarLoanScheduleItem(
          month: month,
          payment: monthlyPayment,
          principal: monthlyPrincipal,
          interest: monthlyInterest,
          remainingBalance: remainingBalance,
        ),
      );
    }

    return schedule;
  }
}
