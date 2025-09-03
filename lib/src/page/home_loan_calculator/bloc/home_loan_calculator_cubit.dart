// lib/src/page/home_loan_calculator/bloc/home_loan_calculator_cubit.dart
import 'dart:math';
import 'package:fin_calc/src/data/models/home_loan_model.dart';
import 'package:fin_calc/src/page/home_loan_calculator/home_loan_calculator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class HomeLoanCalculatorCubit extends Cubit<HomeLoanCalculatorState> {
  HomeLoanCalculatorCubit() : super(HomeLoanCalculatorInitial()) {
    loadInitialData();
  }

  final _calculationsBox = Hive.box('calculations');
  final String _dataKey = 'home_loan_data';

  void loadInitialData() {
    final savedData = _calculationsBox.get(_dataKey) as HomeLoanModel?;
    if (savedData != null) {
      emit(HomeLoanCalculatorLoaded(calculation: savedData));
    } else {
      emit(HomeLoanCalculatorLoaded(calculation: HomeLoanModel()));
    }
  }

  void calculate({
    required String housePrice,
    required String downPayment,
    required String interestRate,
    required String loanTermYears,
  }) {
    final double price = double.tryParse(housePrice) ?? 0;
    final double down = double.tryParse(downPayment) ?? 0;
    final double interest = double.tryParse(interestRate) ?? 0;
    final int term = int.tryParse(loanTermYears) ?? 0;

    double monthlyPayment = 0;
    if (term > 0 && interest > 0 && price > down) {
      final double loanAmount = price - down;
      final double monthlyInterestRate = (interest / 100) / 12;
      final int numberOfMonths = term * 12;

      monthlyPayment = loanAmount *
          (monthlyInterestRate * pow(1 + monthlyInterestRate, numberOfMonths)) /
          (pow(1 + monthlyInterestRate, numberOfMonths) - 1);
    }

    final newCalculation = HomeLoanModel(
      housePrice: price,
      downPayment: down,
      interestRate: interest,
      loanTermYears: term,
      monthlyPayment: monthlyPayment,
    );

    _calculationsBox.put(_dataKey, newCalculation);
    emit(HomeLoanCalculatorLoaded(calculation: newCalculation));
  }
}