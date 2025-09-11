import 'dart:math';
import 'package:fin_calc/src/data/models/savings_model.dart';

class SavingsYearlyData {
  final int year;
  final double deposits;
  final double interest;
  final double total;

  SavingsYearlyData({required this.year, required this.deposits, required this.interest, required this.total});
}

class SavingsCalculatorService {
  /// คำนวณเวลาที่ต้องใช้เพื่อถึงเป้าหมายการออม
  static SavingsModel calculateSavingsGoal({
    required double savingsGoal,
    required double currentSavings,
    required double monthlyDeposit,
    required double annualInterestRate,
  }) {
    final monthlyRate = annualInterestRate / 100 / 12;

    // เงินที่ต้องออมเพิ่ม
    final remainingAmount = savingsGoal - currentSavings;

    int monthsToGoal;
    double finalAmount;
    double totalDeposits;
    double totalInterest;

    if (monthlyDeposit <= 0) {
      // หากไม่มีการฝากรายเดือน ใช้เฉพาะดอกเบี้ยจากเงินปัจจุบัน
      if (monthlyRate > 0) {
        monthsToGoal = (log(savingsGoal / currentSavings) / log(1 + monthlyRate)).ceil();
      } else {
        monthsToGoal = (remainingAmount / 1).ceil(); // ไม่สามารถถึงเป้าหมายได้
      }
      finalAmount = currentSavings * pow(1 + monthlyRate, monthsToGoal);
      totalDeposits = currentSavings;
    } else {
      // คำนวณด้วยการฝากรายเดือน
      if (monthlyRate > 0) {
        // ใช้สูตรการคำนวณเวลาของ Future Value of Annuity
        final futureValueOfCurrent = currentSavings * pow(1 + monthlyRate, 1);
        final remainingFromAnnuity = savingsGoal - futureValueOfCurrent;

        if (remainingFromAnnuity <= 0) {
          monthsToGoal = 0;
        } else {
          // ใช้การประมาณโดยใช้สูตร
          monthsToGoal = (log(1 + (remainingFromAnnuity * monthlyRate / monthlyDeposit)) / log(1 + monthlyRate)).ceil();
        }
      } else {
        // ไม่มีดอกเบี้ย
        monthsToGoal = (remainingAmount / monthlyDeposit).ceil();
      }

      // คำนวณจำนวนเงินสุดท้าย
      final futureValueOfCurrent = currentSavings * pow(1 + monthlyRate, monthsToGoal);
      final futureValueOfDeposits =
          monthlyRate > 0
              ? monthlyDeposit * ((pow(1 + monthlyRate, monthsToGoal) - 1) / monthlyRate)
              : monthlyDeposit * monthsToGoal;

      finalAmount = futureValueOfCurrent + futureValueOfDeposits;
      totalDeposits = currentSavings + (monthlyDeposit * monthsToGoal);
    }

    totalInterest = finalAmount - totalDeposits;

    final goalAchievementDate = DateTime.now().add(Duration(days: monthsToGoal * 30));

    return SavingsModel(
      savingsGoal: savingsGoal,
      currentSavings: currentSavings,
      monthlyDeposit: monthlyDeposit,
      interestRate: annualInterestRate,
      timeToGoalMonths: monthsToGoal,
      finalAmount: finalAmount,
      totalDeposits: totalDeposits,
      totalInterest: totalInterest,
      calculatedDate: DateTime.now(),
      goalAchievementDate: goalAchievementDate,
    );
  }

  /// สร้างตารางการออมรายเดือน
  static List<SavingsScheduleItem> generateSavingsSchedule({
    required double currentSavings,
    required double monthlyDeposit,
    required double annualInterestRate,
    required int months,
  }) {
    final monthlyRate = annualInterestRate / 100 / 12;
    List<SavingsScheduleItem> schedule = [];

    double currentBalance = currentSavings;
    double totalDeposited = currentSavings;

    for (int month = 1; month <= months; month++) {
      // คำนวณดอกเบี้ยของเดือนนี้
      double interestEarned = currentBalance * monthlyRate;

      // เพิ่มดอกเบี้ย
      currentBalance += interestEarned;

      // เพิ่มเงินฝากรายเดือน
      currentBalance += monthlyDeposit;
      totalDeposited += monthlyDeposit;

      schedule.add(
        SavingsScheduleItem(
          month: month,
          monthlyDeposit: monthlyDeposit,
          interestEarned: interestEarned,
          balance: currentBalance,
          totalDeposited: totalDeposited,
        ),
      );
    }

    return schedule;
  }

  /// แปลงเดือนเป็นข้อความ
  static String formatTimeToGoal(int months) {
    if (months < 12) {
      return '$months เดือน';
    } else {
      final years = months ~/ 12;
      final remainingMonths = months % 12;
      if (remainingMonths == 0) {
        return '$years ปี';
      } else {
        return '$years ปี $remainingMonths เดือน';
      }
    }
  }

  /// คำนวณเปอร์เซ็นต์ความคืบหน้า
  static double calculateProgress(double currentSavings, double savingsGoal) {
    if (savingsGoal <= 0) return 0;
    final progress = (currentSavings / savingsGoal) * 100;
    return progress > 100 ? 100 : progress;
  }

  /// คำนวณข้อมูลรายปีสำหรับกราฟ
  static List<SavingsYearlyData> generateYearlyData({
    required double currentSavings,
    required double monthlyDeposit,
    required double annualInterestRate,
    required int totalMonths,
  }) {
    if (totalMonths <= 0) return [];

    final monthlyRate = annualInterestRate / 100 / 12;
    List<SavingsYearlyData> yearlyData = [];

    double balance = currentSavings;
    double yearlyDeposits = 0;
    double yearlyInterest = 0;

    for (int month = 1; month <= totalMonths; month++) {
      // เพิ่มเงินฝากรายเดือน
      balance += monthlyDeposit;
      yearlyDeposits += monthlyDeposit;

      // คำนวณดอกเบี้ยรายเดือน
      double monthlyInterest = balance * monthlyRate;
      balance += monthlyInterest;
      yearlyInterest += monthlyInterest;

      // เก็บข้อมูลทุกสิ้นปี หรือเดือนสุดท้าย
      if (month % 12 == 0 || month == totalMonths) {
        int year = (month / 12).ceil();
        yearlyData.add(
          SavingsYearlyData(year: year, deposits: yearlyDeposits, interest: yearlyInterest, total: balance),
        );

        // รีเซ็ตตัวนับสำหรับปีถัดไป
        yearlyDeposits = 0;
        yearlyInterest = 0;
      }
    }

    return yearlyData;
  }
}
