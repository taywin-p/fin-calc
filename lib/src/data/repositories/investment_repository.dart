import 'package:fin_calc/src/data/models/investment_model.dart';

abstract class IInvestmentRepository {
  Future<InvestmentModel?> getInitialData();
  Future<void> saveData(InvestmentModel data);
  Future<void> clearData();
}
