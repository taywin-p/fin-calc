import 'package:fin_calc/src/data/models/retirement_model.dart';
import 'package:fin_calc/src/data/repositories/retirement_repository.dart';
import 'package:hive/hive.dart';

class RetirementRepositoryImpl implements IRetirementRepository {
  final Box _calculationsBox = Hive.box('calculations');
  final String _dataKey = 'retirement_data';

  @override
  Future<RetirementModel?> getInitialData() async {
    final savedData = _calculationsBox.get(_dataKey);
    return savedData as RetirementModel?;
  }

  @override
  Future<void> saveData(RetirementModel data) async {
    await _calculationsBox.put(_dataKey, data);
  }

  @override
  Future<void> clearData() async {
    await _calculationsBox.delete(_dataKey);
  }
}
