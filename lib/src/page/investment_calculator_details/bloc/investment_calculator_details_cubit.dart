import 'package:flutter_bloc/flutter_bloc.dart';
import '../investment_calculator_details_state.dart';

class InvestmentCalculatorDetailsCubit extends Cubit<InvestmentCalculatorDetailsState> {
  InvestmentCalculatorDetailsCubit() : super(InvestmentCalculatorDetailsInitial()) {
    _initialize();
  }

  bool _isSummaryVisible = true;
  bool _isChartsVisible = true;

  bool get isSummaryVisible => _isSummaryVisible;
  bool get isChartsVisible => _isChartsVisible;

  void _initialize() {
    emit(const InvestmentCalculatorDetailsLoaded());
  }

  void toggleSummaryVisibility() {
    _isSummaryVisible = !_isSummaryVisible;
    if (state is InvestmentCalculatorDetailsLoaded) {
      emit((state as InvestmentCalculatorDetailsLoaded).copyWith(isSummaryVisible: _isSummaryVisible));
    }
  }

  void toggleChartsVisibility() {
    _isChartsVisible = !_isChartsVisible;
    if (state is InvestmentCalculatorDetailsLoaded) {
      emit((state as InvestmentCalculatorDetailsLoaded).copyWith(isChartsVisible: _isChartsVisible));
    }
  }
}
