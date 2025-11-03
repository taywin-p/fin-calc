import 'dart:math';
import 'package:fin_calc/src/data/models/retirement_model.dart';

class RetirementCalculatorService {
  /// คำนวณการวางแผนเกษียณ
  static RetirementModel calculateRetirement({
    required int currentAge,
    required int retirementAge,
    required double currentSavings,
    required double annualInterestRate,
    required double inflationRate,
    required int lifeExpectancy,
    required double monthlyExpenses,
  }) {
    // คำนวณระยะเวลา
    final yearsUntilRetirement = retirementAge - currentAge;
    final yearsInRetirement = lifeExpectancy - retirementAge;

    // ค่าใช้จ่าย ณ ปัจจุบัน
    final currentMonthlyExpenses = monthlyExpenses;

    // คำนวณค่าใช้จ่าย ณ วันเกษียณ (บวกเงินเฟ้อทุกปี)
    final retirementMonthlyExpenses = monthlyExpenses * pow(1 + inflationRate / 100, yearsUntilRetirement);

    // คำนวณเงินที่ต้องมี ณ วันเกษียณ
    // ใช้สูตร Present Value of Annuity สำหรับคำนวณเงินที่ต้องมีเพื่อใช้จ่ายหลังเกษียณ
    // PV = PMT × [(1 - (1 + r)^-n) / r]
    // โดยที่ r = (interest rate - inflation rate) / 12 เพื่อหักเงินเฟ้อออก
    
    final realReturnRate = (annualInterestRate - inflationRate) / 100; // อัตราผลตอบแทนจริงหลังหักเงินเฟ้อ
    final monthlyRealReturn = realReturnRate / 12;
    final monthsInRetirement = yearsInRetirement * 12;

    double totalRetirementNeeded;
    if (monthlyRealReturn > 0) {
      // ถ้ามีอัตราผลตอบแทนจริงบวก
      totalRetirementNeeded = retirementMonthlyExpenses * 
        ((1 - pow(1 + monthlyRealReturn, -monthsInRetirement)) / monthlyRealReturn);
    } else if (monthlyRealReturn < 0) {
      // ถ้าอัตราผลตอบแทนจริงติดลบ (เงินเฟ้อสูงกว่าดอกเบี้ย)
      // ต้องมีเงินมากขึ้นเพราะเงินจะหายค่าเร็วกว่า
      totalRetirementNeeded = retirementMonthlyExpenses * 
        ((pow(1 - monthlyRealReturn, monthsInRetirement) - 1) / (-monthlyRealReturn));
    } else {
      // ถ้าอัตราผลตอบแทนจริงเป็น 0 (ดอกเบี้ยเท่ากับเงินเฟ้อ)
      totalRetirementNeeded = retirementMonthlyExpenses * monthsInRetirement;
    }

    // คำนวณเงินเก็บเดิมที่จะโตเป็นเท่าไหร่ ณ วันเกษียณ
    final currentSavingsGrowth = currentSavings * pow(1 + annualInterestRate / 100, yearsUntilRetirement);

    // คำนวณว่าต้องเก็บเพิ่มอีกเท่าไหร่
    final additionalSavingsNeeded = max(0.0, totalRetirementNeeded - currentSavingsGrowth);

    // คำนวณว่าต้องเก็บเพิ่มเท่าไหร่ต่อเดือน
    // ใช้สูตร Future Value of Annuity: FV = PMT × [((1 + r)^n - 1) / r]
    // จัดรูปเป็น: PMT = FV / [((1 + r)^n - 1) / r]
    double monthlySavingsNeeded = 0;
    if (additionalSavingsNeeded > 0) {
      final monthlyRate = annualInterestRate / 100 / 12;
      final monthsUntilRetirement = yearsUntilRetirement * 12;
      
      if (monthlyRate > 0) {
        monthlySavingsNeeded = additionalSavingsNeeded / 
          ((pow(1 + monthlyRate, monthsUntilRetirement) - 1) / monthlyRate);
      } else {
        // ถ้าไม่มีดอกเบี้ย
        monthlySavingsNeeded = additionalSavingsNeeded / monthsUntilRetirement;
      }
    }

    return RetirementModel(
      currentAge: currentAge,
      retirementAge: retirementAge,
      currentSavings: currentSavings,
      annualInterestRate: annualInterestRate,
      inflationRate: inflationRate,
      lifeExpectancy: lifeExpectancy,
      monthlyExpenses: monthlyExpenses,
      yearsUntilRetirement: yearsUntilRetirement,
      yearsInRetirement: yearsInRetirement,
      currentMonthlyExpenses: currentMonthlyExpenses,
      retirementMonthlyExpenses: retirementMonthlyExpenses,
      totalRetirementNeeded: totalRetirementNeeded,
      currentSavingsGrowth: currentSavingsGrowth,
      additionalSavingsNeeded: additionalSavingsNeeded,
      monthlySavingsNeeded: monthlySavingsNeeded,
      calculatedDate: DateTime.now(),
    );
  }
}
