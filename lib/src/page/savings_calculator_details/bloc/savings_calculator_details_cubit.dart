import 'package:flutter_bloc/flutter_bloc.dart';
import '../savings_calculator_details_state.dart';

class SavingsCalculatorDetailsCubit extends Cubit<SavingsCalculatorDetailsState> {
  SavingsCalculatorDetailsCubit() : super(SavingsCalculatorDetailsInitial());

  dynamic calculation;
  bool isSummaryVisible = true;

  void loadData(dynamic calc) {
    calculation = calc;
    emit(SavingsCalculatorDetailsLoaded(isSummaryVisible: isSummaryVisible));
  }

  void toggleSummaryVisibility() {
    isSummaryVisible = !isSummaryVisible;
    emit(SavingsCalculatorDetailsLoaded(isSummaryVisible: isSummaryVisible));
  }
}