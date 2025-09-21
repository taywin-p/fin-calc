import 'dart:math';
import '../models/investment_model.dart';

class InvestmentService {
  /// คำนวณการลงทุนแบบ Growth ง่ายๆ
  /// การเติบโตแบบเรียบง่าย: FinalValue = (InitialAmount + MonthlyContribution * Years * 12) * (1 + AnnualReturn/100)^Years
  static InvestmentModel calculateInvestment({
    required double initialInvestment,
    required double monthlyContribution,
    required double annualReturnRate,
    required int investmentYears,
  }) {
    // คำนวณเงินลงทุนรวม
    final totalContributions = initialInvestment + (monthlyContribution * 12 * investmentYears);

    // คำนวณการเติบโต: เงินลงทุนรวม * (1 + อัตราผลตอบแทน)^ปี
    final growthMultiplier = pow(1 + (annualReturnRate / 100), investmentYears);
    final finalAmount = totalContributions * growthMultiplier;

    final totalReturns = finalAmount - totalContributions;

    return InvestmentModel(
      initialInvestment: initialInvestment,
      monthlyContribution: monthlyContribution,
      annualReturnRate: annualReturnRate,
      investmentYears: investmentYears,
      finalAmount: finalAmount,
      totalContributions: totalContributions,
      totalReturns: totalReturns,
      calculatedDate: DateTime.now(),
    );
  }

  /// สร้างตารางการลงทุนรายปี
  static List<InvestmentScheduleItem> generateInvestmentSchedule({
    required double initialInvestment,
    required double monthlyContribution,
    required double annualReturnRate,
    required int investmentYears,
  }) {
    final List<InvestmentScheduleItem> schedule = [];
    final annualContribution = monthlyContribution * 12;

    double totalContributed = initialInvestment;
    double totalValue = initialInvestment;
    double cumulativeReturns = 0.0;

    for (int year = 1; year <= investmentYears; year++) {
      // เพิ่มเงินลงทุนรายปี
      totalContributed += annualContribution;

      // คำนวณการเติบโตของเงินทั้งหมด
      totalValue = totalContributed * pow(1 + (annualReturnRate / 100), year);

      // คำนวณผลตอบแทนในปีนี้
      final currentReturns = totalValue - totalContributed;
      final yearlyReturns = currentReturns - cumulativeReturns;

      cumulativeReturns = currentReturns;

      schedule.add(
        InvestmentScheduleItem(
          year: year,
          yearlyContribution: annualContribution,
          yearlyReturns: yearlyReturns,
          totalValue: totalValue,
          totalContributed: totalContributed,
          cumulativeReturns: cumulativeReturns,
        ),
      );
    }

    return schedule;
  }

  /// คำนวณการลงทุนแบบ SIP (Systematic Investment Plan)
  static InvestmentModel calculateSIP({
    required double monthlyInvestment,
    required double expectedReturnRate,
    required int investmentYears,
  }) {
    return calculateInvestment(
      initialInvestment: 0,
      monthlyContribution: monthlyInvestment,
      annualReturnRate: expectedReturnRate,
      investmentYears: investmentYears,
    );
  }

  /// คำนวณการลงทุนแบบก้อน (Lump Sum)
  static InvestmentModel calculateLumpSum({
    required double lumpSumAmount,
    required double expectedReturnRate,
    required int investmentYears,
  }) {
    return calculateInvestment(
      initialInvestment: lumpSumAmount,
      monthlyContribution: 0,
      annualReturnRate: expectedReturnRate,
      investmentYears: investmentYears,
    );
  }

  /// คำนวณเงินที่ต้องลงทุนรายเดือนเพื่อให้ได้เป้าหมาย
  static double calculateMonthlyInvestmentNeeded({
    required double targetAmount,
    required double expectedReturnRate,
    required int investmentYears,
    double initialInvestment = 0,
  }) {
    final growthMultiplier = pow(1 + (expectedReturnRate / 100), investmentYears);
    final targetAfterInitial = targetAmount / growthMultiplier - initialInvestment;

    if (targetAfterInitial <= 0) {
      return 0; // เงินลงทุนครั้งแรกเพียงพอแล้ว
    }

    return targetAfterInitial / (12 * investmentYears);
  }

  /// คำนวณระยะเวลาที่ต้องใช้ในการลงทุนเพื่อให้ได้เป้าหมาย
  static double calculateYearsNeeded({
    required double targetAmount,
    required double monthlyInvestment,
    required double expectedReturnRate,
    double initialInvestment = 0,
  }) {
    final totalMonthlyContribution = monthlyInvestment * 12;

    if (totalMonthlyContribution <= 0) {
      // ถ้าไม่มีการลงทุนรายเดือน ใช้เฉพาะเงินลงทุนครั้งแรก
      return log(targetAmount / initialInvestment) / log(1 + expectedReturnRate / 100);
    }

    // ใช้การประมาณแบบง่าย
    // targetAmount = (initialInvestment + totalContribution * years) * (1 + rate)^years
    // แก้สมการโดยการลองค่า
    for (double years = 0.1; years <= 100; years += 0.1) {
      final totalContribution = initialInvestment + (totalMonthlyContribution * years);
      final projectedAmount = totalContribution * pow(1 + expectedReturnRate / 100, years);

      if (projectedAmount >= targetAmount) {
        return years;
      }
    }

    return 100; // ถ้าไม่เจอ return ค่าสูงๆ
  }

  /// คำนวณ CAGR (Compound Annual Growth Rate)
  static double calculateCAGR({required double initialValue, required double finalValue, required int years}) {
    if (initialValue <= 0 || finalValue <= 0 || years <= 0) {
      return 0;
    }

    return (pow(finalValue / initialValue, 1 / years) - 1) * 100;
  }

  /// เปรียบเทียบการลงทุนหลายรูปแบบ
  static Map<String, InvestmentModel> compareInvestmentStrategies({
    required double amount,
    required double returnRate,
    required int years,
  }) {
    return {
      'Lump Sum': calculateLumpSum(lumpSumAmount: amount, expectedReturnRate: returnRate, investmentYears: years),
      'SIP Monthly': calculateSIP(
        monthlyInvestment: amount / 12 / years,
        expectedReturnRate: returnRate,
        investmentYears: years,
      ),
      'Mixed (50/50)': calculateInvestment(
        initialInvestment: amount * 0.5,
        monthlyContribution: (amount * 0.5) / (years * 12),
        annualReturnRate: returnRate,
        investmentYears: years,
      ),
    };
  }
}
