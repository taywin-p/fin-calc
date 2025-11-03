part of 'bloc/retirement_calculator_cubit.dart';

abstract class RetirementCalculatorState extends Equatable {
  const RetirementCalculatorState();

  @override
  List<Object> get props => [];
}

class RetirementCalculatorInitial extends RetirementCalculatorState {}

class RetirementCalculatorLoading extends RetirementCalculatorState {}

class RetirementCalculatorLoaded extends RetirementCalculatorState {
  final RetirementModel calculation;

  const RetirementCalculatorLoaded({required this.calculation});

  @override
  List<Object> get props => [calculation];
}

class RetirementCalculatorError extends RetirementCalculatorState {
  final String message;

  const RetirementCalculatorError({required this.message});

  @override
  List<Object> get props => [message];
}
