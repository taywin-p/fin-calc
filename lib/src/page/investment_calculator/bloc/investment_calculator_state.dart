part of 'investment_calculator_cubit.dart';

abstract class InvestmentCalculatorState extends Equatable {
  const InvestmentCalculatorState();

  @override
  List<Object?> get props => [];
}

class InvestmentCalculatorInitial extends InvestmentCalculatorState {}

class InvestmentCalculatorLoading extends InvestmentCalculatorState {}

class InvestmentCalculatorLoaded extends InvestmentCalculatorState {
  final InvestmentModel calculation;

  const InvestmentCalculatorLoaded({required this.calculation});

  @override
  List<Object?> get props => [calculation];
}

class InvestmentCalculatorError extends InvestmentCalculatorState {
  final String message;

  const InvestmentCalculatorError({required this.message});

  @override
  List<Object?> get props => [message];
}
