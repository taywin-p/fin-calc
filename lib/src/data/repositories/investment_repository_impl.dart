import 'package:fin_calc/src/data/models/investment_model.dart';
import 'package:fin_calc/src/data/repositories/investment_repository.dart';
import 'package:hive/hive.dart';

class InvestmentRepositoryImpl implements IInvestmentRepository {
  final Box _calculationsBox = Hive.box('calculations');
  final String _dataKey = 'investment_data';

  @override
  Future<InvestmentModel?> getInitialData() async {
    final savedData = _calculationsBox.get(_dataKey);
    return savedData as InvestmentModel?;
  }

  @override
  Future<void> saveData(InvestmentModel data) async {
    await _calculationsBox.put(_dataKey, data);
  }

  @override
  Future<void> clearData() async {
    await _calculationsBox.delete(_dataKey);
  }
}
