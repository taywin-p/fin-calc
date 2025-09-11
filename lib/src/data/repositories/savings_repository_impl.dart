import 'package:fin_calc/src/data/models/savings_model.dart';
import 'package:fin_calc/src/data/repositories/savings_repository.dart';
import 'package:hive/hive.dart';

class SavingsRepositoryImpl implements ISavingsRepository {
  final Box _calculationsBox = Hive.box('calculations');
  final String _dataKey = 'savings_data';

  @override
  Future<SavingsModel?> getInitialData() async {
    final savedData = _calculationsBox.get(_dataKey);
    return savedData as SavingsModel?;
  }

  @override
  Future<void> saveData(SavingsModel data) async {
    await _calculationsBox.put(_dataKey, data);
  }

  @override
  Future<void> clearData() async {
    await _calculationsBox.delete(_dataKey);
  }
}
