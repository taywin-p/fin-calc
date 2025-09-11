part of 'bloc/savings_calculator_cubit.dart';

abstract class SavingsCalculatorState extends Equatable {
  const SavingsCalculatorState();

  @override
  List<Object> get props => [];
}

class SavingsCalculatorInitial extends SavingsCalculatorState {}

class SavingsCalculatorLoading extends SavingsCalculatorState {}

class SavingsCalculatorLoaded extends SavingsCalculatorState {
  final SavingsModel calculation;

  const SavingsCalculatorLoaded({required this.calculation});

  @override
  List<Object> get props => [calculation];
}

class SavingsCalculatorError extends SavingsCalculatorState {
  final String message;

  const SavingsCalculatorError({required this.message});

  @override
  List<Object> get props => [message];
}
