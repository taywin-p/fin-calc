part of 'bloc/car_loan_calculator_details_cubit.dart';

abstract class CarLoanCalculatorDetailsState extends Equatable {
  const CarLoanCalculatorDetailsState();

  @override
  List<Object> get props => [];
}

class CarLoanCalculatorDetailsSummaryVisible extends CarLoanCalculatorDetailsState {
  const CarLoanCalculatorDetailsSummaryVisible();
}

class CarLoanCalculatorDetailsSummaryHidden extends CarLoanCalculatorDetailsState {
  const CarLoanCalculatorDetailsSummaryHidden();
}
