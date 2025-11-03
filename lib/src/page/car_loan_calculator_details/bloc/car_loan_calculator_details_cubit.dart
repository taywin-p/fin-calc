import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part '../car_loan_calculator_details_state.dart';

class CarLoanCalculatorDetailsCubit extends Cubit<CarLoanCalculatorDetailsState> {
  dynamic calculation;

  CarLoanCalculatorDetailsCubit() : super(const CarLoanCalculatorDetailsSummaryVisible());

  void loadData(dynamic data) {
    calculation = data;
  }

  void toggleSummaryVisibility() {
    if (state is CarLoanCalculatorDetailsSummaryVisible) {
      emit(const CarLoanCalculatorDetailsSummaryHidden());
    } else {
      emit(const CarLoanCalculatorDetailsSummaryVisible());
    }
  }

  bool get isSummaryVisible => state is CarLoanCalculatorDetailsSummaryVisible;
}
