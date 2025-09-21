import 'package:equatable/equatable.dart';

abstract class InvestmentCalculatorDetailsState extends Equatable {
  const InvestmentCalculatorDetailsState();

  @override
  List<Object> get props => [];
}

class InvestmentCalculatorDetailsInitial extends InvestmentCalculatorDetailsState {}

class InvestmentCalculatorDetailsLoading extends InvestmentCalculatorDetailsState {}

class InvestmentCalculatorDetailsLoaded extends InvestmentCalculatorDetailsState {
  final bool isSummaryVisible;
  final bool isChartsVisible;

  const InvestmentCalculatorDetailsLoaded({this.isSummaryVisible = true, this.isChartsVisible = true});

  @override
  List<Object> get props => [isSummaryVisible, isChartsVisible];

  InvestmentCalculatorDetailsLoaded copyWith({bool? isSummaryVisible, bool? isChartsVisible}) {
    return InvestmentCalculatorDetailsLoaded(
      isSummaryVisible: isSummaryVisible ?? this.isSummaryVisible,
      isChartsVisible: isChartsVisible ?? this.isChartsVisible,
    );
  }
}

class InvestmentCalculatorDetailsError extends InvestmentCalculatorDetailsState {
  final String message;

  const InvestmentCalculatorDetailsError(this.message);

  @override
  List<Object> get props => [message];
}
