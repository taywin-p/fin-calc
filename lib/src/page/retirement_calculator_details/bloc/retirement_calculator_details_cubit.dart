import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part '../retirement_calculator_details_state.dart';

class RetirementCalculatorDetailsCubit extends Cubit<RetirementCalculatorDetailsState> {
  dynamic calculation;
  bool isSummaryVisible = true;

  RetirementCalculatorDetailsCubit() : super(RetirementCalculatorDetailsInitial());

  void loadData(dynamic data) {
    calculation = data;
  }

  void toggleSummaryVisibility() {
    isSummaryVisible = !isSummaryVisible;
    emit(RetirementCalculatorDetailsInitial());
  }
}
