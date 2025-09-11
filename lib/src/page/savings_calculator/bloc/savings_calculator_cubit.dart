import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fin_calc/src/data/models/savings_model.dart';
import 'package:fin_calc/src/data/repositories/savings_repository.dart';
import 'package:fin_calc/src/data/services/savings_calculator_service.dart';

part '../savings_calculator_state.dart';

class SavingsCalculatorCubit extends Cubit<SavingsCalculatorState> {
  final ISavingsRepository repository;

  SavingsCalculatorCubit({required this.repository}) : super(SavingsCalculatorInitial()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final savedData = await repository.getInitialData();
      if (savedData != null) {
        emit(SavingsCalculatorLoaded(calculation: savedData));
      } else {
        emit(SavingsCalculatorInitial());
      }
    } catch (e) {
      emit(SavingsCalculatorError(message: e.toString()));
    }
  }

  Future<void> calculate({
    required String savingsGoal,
    required String currentSavings,
    required String monthlyDeposit,
    required String interestRate,
  }) async {
    try {
      emit(SavingsCalculatorLoading());

      // Validate input
      final goal = double.tryParse(savingsGoal);
      final current = double.tryParse(currentSavings);
      final monthly = double.tryParse(monthlyDeposit);
      final rate = double.tryParse(interestRate);

      if (goal == null || goal <= 0) {
        emit(const SavingsCalculatorError(message: 'กรุณากรอกเป้าหมายการออมให้ถูกต้อง'));
        return;
      }

      if (current == null || current < 0) {
        emit(const SavingsCalculatorError(message: 'กรุณากรอกเงินออมปัจจุบันให้ถูกต้อง'));
        return;
      }

      if (monthly == null || monthly < 0) {
        emit(const SavingsCalculatorError(message: 'กรุณากรอกเงินออมรายเดือนให้ถูกต้อง'));
        return;
      }

      if (rate == null || rate < 0 || rate > 20) {
        emit(const SavingsCalculatorError(message: 'กรุณากรอกอัตราดอกเบี้ยให้ถูกต้อง (0-20%)'));
        return;
      }

      if (current >= goal) {
        emit(const SavingsCalculatorError(message: 'คุณมีเงินออมเพียงพอถึงเป้าหมายแล้ว!'));
        return;
      }

      if (monthly == 0 && rate == 0) {
        emit(const SavingsCalculatorError(message: 'ต้องมีการออมรายเดือนหรือดอกเบี้ยเพื่อถึงเป้าหมาย'));
        return;
      }

      // Calculate savings goal
      final calculation = SavingsCalculatorService.calculateSavingsGoal(
        savingsGoal: goal,
        currentSavings: current,
        monthlyDeposit: monthly,
        annualInterestRate: rate,
      );

      // Save data
      await repository.saveData(calculation);

      emit(SavingsCalculatorLoaded(calculation: calculation));
    } catch (e) {
      emit(SavingsCalculatorError(message: 'เกิดข้อผิดพลาดในการคำนวณ: ${e.toString()}'));
    }
  }

  Future<void> clear() async {
    try {
      await repository.clearData();
      emit(SavingsCalculatorInitial());
    } catch (e) {
      emit(SavingsCalculatorError(message: e.toString()));
    }
  }
}
