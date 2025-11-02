import 'package:equatable/equatable.dart';

abstract class SavingsCalculatorDetailsState extends Equatable {
  const SavingsCalculatorDetailsState();

  @override
  List<Object> get props => [];
}

class SavingsCalculatorDetailsInitial extends SavingsCalculatorDetailsState {}

class SavingsCalculatorDetailsLoaded extends SavingsCalculatorDetailsState {
  final bool isSummaryVisible;

  const SavingsCalculatorDetailsLoaded({this.isSummaryVisible = true});

  @override
  List<Object> get props => [isSummaryVisible];
}

class SavingsCalculatorDetailsError extends SavingsCalculatorDetailsState {
  final String message;

  const SavingsCalculatorDetailsError(this.message);

  @override
  List<Object> get props => [message];
}