// lib/src/page/home_loan_calculator/bloc/home_loan_calculator_cubit.dart
import 'package:fin_calc/src/data/models/home_loan_model.dart';
import 'package:fin_calc/src/data/repositories/home_loan_repository.dart';
import 'package:fin_calc/src/data/services/loan_calculator_service.dart';
import 'package:fin_calc/src/page/home_loan_calculator/home_loan_calculator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeLoanCalculatorCubit extends Cubit<HomeLoanCalculatorState> {
  final IHomeLoanRepository _repository;

  HomeLoanCalculatorCubit({required IHomeLoanRepository repository})
    : _repository = repository,
      super(HomeLoanCalculatorInitial()) {
    loadInitialData();
  }

  void loadInitialData() async {
    final savedData = await _repository.getInitialData();
    if (savedData != null) {
      emit(HomeLoanCalculatorLoaded(calculation: savedData));
    } else {
      emit(HomeLoanCalculatorLoaded(calculation: const HomeLoanModel()));
    }
  }

  void clear() async {
    await _repository.clearData();
    emit(HomeLoanCalculatorLoaded(calculation: const HomeLoanModel()));
  }

  void calculate({
    required String housePrice,
    required String downPayment,
    required String interestRate,
    required String loanTermYears,
  }) async {
    final double price = double.tryParse(housePrice) ?? 0;
    final double down = double.tryParse(downPayment) ?? 0;
    final double interest = double.tryParse(interestRate) ?? 0;
    final int term = int.tryParse(loanTermYears) ?? 0;

    if (term > 0 && interest > 0 && price > down && price > 0) {
      final newCalculation = LoanCalculatorService.calculateLoan(
        housePrice: price,
        downPayment: down,
        interestRate: interest,
        loanTermYears: term,
      );

      await _repository.saveData(newCalculation);
      emit(HomeLoanCalculatorLoaded(calculation: newCalculation));
    } else {
      // Handle invalid input
      final invalidCalculation = HomeLoanModel(
        housePrice: price,
        downPayment: down,
        interestRate: interest,
        loanTermYears: term,
        monthlyPayment: 0,
        loanAmount: 0,
        totalInterest: 0,
        totalPayment: 0,
        calculatedDate: DateTime.now(),
      );
      emit(HomeLoanCalculatorLoaded(calculation: invalidCalculation));
    }
  }
}
