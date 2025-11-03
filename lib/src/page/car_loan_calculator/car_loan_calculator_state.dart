part of 'bloc/car_loan_calculator_cubit.dart';

abstract class CarLoanCalculatorState extends Equatable {
  const CarLoanCalculatorState();

  @override
  List<Object> get props => [];
}

class CarLoanCalculatorInitial extends CarLoanCalculatorState {}

class CarLoanCalculatorLoading extends CarLoanCalculatorState {}

class CarLoanCalculatorLoaded extends CarLoanCalculatorState {
  final CarLoanModel calculation;

  const CarLoanCalculatorLoaded({required this.calculation});

  @override
  List<Object> get props => [calculation];
}

class CarLoanCalculatorError extends CarLoanCalculatorState {
  final String message;

  const CarLoanCalculatorError({required this.message});

  @override
  List<Object> get props => [message];
}
