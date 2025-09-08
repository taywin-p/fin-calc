import 'package:flutter_bloc/flutter_bloc.dart';
import '../home_loan_calculator_details_state.dart';

class HomeLoanCalculatorDetailsCubit extends Cubit<HomeLoanCalculatorDetailsState> {
  HomeLoanCalculatorDetailsCubit() : super(const HomeLoanCalculatorDetailsSummaryVisible()); // Default แสดงส่วนสรุป

  void toggleSummaryVisibility() {
    if (state is HomeLoanCalculatorDetailsSummaryVisible) {
      emit(const HomeLoanCalculatorDetailsSummaryHidden());
    } else {
      emit(const HomeLoanCalculatorDetailsSummaryVisible());
    }
  }

  bool get isSummaryVisible => state is HomeLoanCalculatorDetailsSummaryVisible;
}
