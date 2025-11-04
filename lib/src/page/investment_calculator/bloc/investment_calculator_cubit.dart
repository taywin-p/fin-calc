import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fin_calc/src/data/models/investment_model.dart';
import 'package:fin_calc/src/data/repositories/investment_repository.dart';
import 'package:fin_calc/src/data/services/investment_service.dart';

part 'investment_calculator_state.dart';

class InvestmentCalculatorCubit extends Cubit<InvestmentCalculatorState> {
  final IInvestmentRepository repository;

  InvestmentCalculatorCubit({required this.repository}) : super(InvestmentCalculatorInitial()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final savedData = await repository.getInitialData();
      if (savedData != null) {
        emit(InvestmentCalculatorLoaded(calculation: savedData));
      } else {
        emit(InvestmentCalculatorInitial());
      }
    } catch (e) {
      emit(InvestmentCalculatorError(message: e.toString()));
    }
  }

  Future<void> calculate({
    required String initialInvestment,
    required String monthlyContribution,
    required String annualReturnRate,
    required String investmentYears,
  }) async {
    try {
      emit(InvestmentCalculatorLoading());

      // Validate input
      final initial = double.tryParse(initialInvestment);
      final monthly = double.tryParse(monthlyContribution);
      final returnRate = double.tryParse(annualReturnRate);
      final years = int.tryParse(investmentYears);

      if (initial == null || initial < 0) {
        emit(const InvestmentCalculatorError(message: 'กรุณากรอกเงินลงทุนครั้งแรกให้ถูกต้อง'));
        return;
      }

      if (monthly == null || monthly < 0) {
        emit(const InvestmentCalculatorError(message: 'กรุณากรอกเงินลงทุนรายเดือนให้ถูกต้อง'));
        return;
      }

      if (returnRate == null || returnRate < 0 || returnRate > 50) {
        emit(const InvestmentCalculatorError(message: 'กรุณากรอกอัตราผลตอบแทนให้ถูกต้อง (0-50%)'));
        return;
      }

      if (years == null || years <= 0 || years > 50) {
        emit(const InvestmentCalculatorError(message: 'กรุณากรอกระยะเวลาการลงทุนให้ถูกต้อง (1-50 ปี)'));
        return;
      }

      if (initial == 0 && monthly == 0) {
        emit(const InvestmentCalculatorError(message: 'ต้องมีเงินลงทุนครั้งแรกหรือรายเดือน'));
        return;
      }

      // Calculate investment
      final calculation = InvestmentService.calculateInvestment(
        initialInvestment: initial,
        monthlyContribution: monthly,
        annualReturnRate: returnRate,
        investmentYears: years,
      );

      // Save data
      await repository.saveData(calculation);

      emit(InvestmentCalculatorLoaded(calculation: calculation));
    } catch (e) {
      emit(InvestmentCalculatorError(message: 'เกิดข้อผิดพลาดในการคำนวณ: ${e.toString()}'));
    }
  }

  Future<void> clear() async {
    try {
      await repository.clearData();
      emit(InvestmentCalculatorInitial());
    } catch (e) {
      emit(InvestmentCalculatorError(message: e.toString()));
    }
  }
}
