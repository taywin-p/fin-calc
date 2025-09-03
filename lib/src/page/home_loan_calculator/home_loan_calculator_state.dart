import 'package:fin_calc/src/data/models/home_loan_model.dart';
import 'package:equatable/equatable.dart';


abstract class HomeLoanCalculatorState extends Equatable {
  const HomeLoanCalculatorState();

  @override
  List<Object?> get props => [];
}

class HomeLoanCalculatorInitial extends HomeLoanCalculatorState {}

class HomeLoanCalculatorLoaded extends HomeLoanCalculatorState {
  final HomeLoanModel calculation;

  const HomeLoanCalculatorLoaded({required this.calculation});

  @override
  List<Object?> get props => [calculation];
}