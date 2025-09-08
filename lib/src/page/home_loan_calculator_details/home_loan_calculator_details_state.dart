import 'package:equatable/equatable.dart';

abstract class HomeLoanCalculatorDetailsState extends Equatable {
  const HomeLoanCalculatorDetailsState();

  @override
  List<Object?> get props => [];
}

class HomeLoanCalculatorDetailsSummaryVisible extends HomeLoanCalculatorDetailsState {
  const HomeLoanCalculatorDetailsSummaryVisible();
}

class HomeLoanCalculatorDetailsSummaryHidden extends HomeLoanCalculatorDetailsState {
  const HomeLoanCalculatorDetailsSummaryHidden();
}
