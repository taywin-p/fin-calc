import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fin_calc/src/data/models/retirement_model.dart';
import 'package:fin_calc/src/data/repositories/retirement_repository.dart';
import 'package:fin_calc/src/data/services/retirement_calculator_service.dart';

part '../retirement_calculator_state.dart';

class RetirementCalculatorCubit extends Cubit<RetirementCalculatorState> {
  final IRetirementRepository repository;

  RetirementCalculatorCubit({required this.repository}) : super(RetirementCalculatorInitial()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final savedData = await repository.getInitialData();
      if (savedData != null) {
        emit(RetirementCalculatorLoaded(calculation: savedData));
      } else {
        emit(RetirementCalculatorInitial());
      }
    } catch (e) {
      emit(RetirementCalculatorError(message: e.toString()));
    }
  }

  Future<void> calculate({
    required String currentAge,
    required String retirementAge,
    required String currentSavings,
    required String annualInterestRate,
    required String inflationRate,
    required String lifeExpectancy,
    required String monthlyExpenses,
  }) async {
    try {
      emit(RetirementCalculatorLoading());

      // Validate input
      final currentAgeInt = int.tryParse(currentAge);
      final retirementAgeInt = int.tryParse(retirementAge);
      final currentSavingsDbl = double.tryParse(currentSavings);
      final interestRate = double.tryParse(annualInterestRate);
      final inflation = double.tryParse(inflationRate);
      final lifeExpectancyInt = int.tryParse(lifeExpectancy);
      final monthlyExp = double.tryParse(monthlyExpenses);

      if (currentAgeInt == null || currentAgeInt <= 0 || currentAgeInt > 100) {
        emit(const RetirementCalculatorError(message: 'กรุณากรอกอายุปัจจุบันให้ถูกต้อง (1-100 ปี)'));
        return;
      }

      if (retirementAgeInt == null || retirementAgeInt <= 0 || retirementAgeInt > 100) {
        emit(const RetirementCalculatorError(message: 'กรุณากรอกอายุที่จะเกษียณให้ถูกต้อง (1-100 ปี)'));
        return;
      }

      if (retirementAgeInt <= currentAgeInt) {
        emit(const RetirementCalculatorError(message: 'อายุที่จะเกษียณต้องมากกว่าอายุปัจจุบัน'));
        return;
      }

      if (currentSavingsDbl == null || currentSavingsDbl < 0) {
        emit(const RetirementCalculatorError(message: 'กรุณากรอกเงินเก็บเดิมให้ถูกต้อง'));
        return;
      }

      if (interestRate == null || interestRate < 0 || interestRate > 20) {
        emit(const RetirementCalculatorError(message: 'กรุณากรอกอัตราดอกเบี้ยให้ถูกต้อง (0-20%)'));
        return;
      }

      if (inflation == null || inflation < 0 || inflation > 20) {
        emit(const RetirementCalculatorError(message: 'กรุณากรอกอัตราเงินเฟ้อให้ถูกต้อง (0-20%)'));
        return;
      }

      if (lifeExpectancyInt == null || lifeExpectancyInt <= retirementAgeInt || lifeExpectancyInt > 120) {
        emit(const RetirementCalculatorError(message: 'กรุณากรอกอายุคาดหวังให้ถูกต้อง (มากกว่าอายุเกษียณ, ไม่เกิน 120 ปี)'));
        return;
      }

      if (monthlyExp == null || monthlyExp <= 0) {
        emit(const RetirementCalculatorError(message: 'กรุณากรอกค่าใช้จ่ายรายเดือนให้ถูกต้อง'));
        return;
      }

      // Calculate retirement plan
      final calculation = RetirementCalculatorService.calculateRetirement(
        currentAge: currentAgeInt,
        retirementAge: retirementAgeInt,
        currentSavings: currentSavingsDbl,
        annualInterestRate: interestRate,
        inflationRate: inflation,
        lifeExpectancy: lifeExpectancyInt,
        monthlyExpenses: monthlyExp,
      );

      // Save data
      await repository.saveData(calculation);

      emit(RetirementCalculatorLoaded(calculation: calculation));
    } catch (e) {
      emit(RetirementCalculatorError(message: 'เกิดข้อผิดพลาดในการคำนวณ: ${e.toString()}'));
    }
  }

  Future<void> clear() async {
    try {
      await repository.clearData();
      emit(RetirementCalculatorInitial());
    } catch (e) {
      emit(RetirementCalculatorError(message: e.toString()));
    }
  }
}
