import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fin_calc/src/data/models/car_loan_model_v2.dart';

part '../car_loan_calculator_details_state.dart';

class CarLoanCalculatorDetailsCubit extends Cubit<CarLoanCalculatorDetailsState> {
  //เปลี่ยน Type เป็น V2 (Nullable)
  CarLoanModelV2? calculation;

  CarLoanCalculatorDetailsCubit() : super(const CarLoanCalculatorDetailsSummaryVisible());

  // รับ V2
  void loadData(CarLoanModelV2 data) {
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
