import '../models/home_loan_model.dart';

class LoanCalculatorService {
  static HomeLoanModel calculateLoan({
    required double housePrice,
    required double downPayment,
    required double interestRate,
    required int loanTermYears,
  }) {
    final loanAmount = housePrice - downPayment;
    final monthlyInterestRate = interestRate / 100 / 12;
    final numberOfPayments = loanTermYears * 12;

    // คำนวณค่าผ่อนรายเดือน
    final monthlyPayment =
        loanAmount *
        (monthlyInterestRate * pow(1 + monthlyInterestRate, numberOfPayments)) /
        (pow(1 + monthlyInterestRate, numberOfPayments) - 1);

    final totalPayment = monthlyPayment * numberOfPayments;
    final totalInterest = totalPayment - loanAmount;

    return HomeLoanModel(
      housePrice: housePrice,
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

  static List<PaymentScheduleItem> generatePaymentSchedule({
    required double loanAmount,
    required double monthlyPayment,
    required double monthlyInterestRate,
    required int numberOfPayments,
  }) {
    List<PaymentScheduleItem> schedule = [];
    double remainingBalance = loanAmount;

    for (int month = 1; month <= numberOfPayments; month++) {
      final interestPayment = remainingBalance * monthlyInterestRate;
      final principalPayment = monthlyPayment - interestPayment;
      remainingBalance -= principalPayment;

      if (remainingBalance < 0) {
        remainingBalance = 0;
      }

      schedule.add(
        PaymentScheduleItem(
          month: month,
          payment: monthlyPayment,
          principal: principalPayment,
          interest: interestPayment,
          remainingBalance: remainingBalance,
        ),
      );

      if (remainingBalance <= 0) break;
    }

    return schedule;
  }
}

// Helper function
double pow(double base, int exponent) {
  double result = 1.0;
  for (int i = 0; i < exponent; i++) {
    result *= base;
  }
  return result;
}
