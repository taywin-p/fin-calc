import 'package:fin_calc/src/data/models/savings_model.dart';

abstract class ISavingsRepository {
  Future<SavingsModel?> getInitialData();
  Future<void> saveData(SavingsModel data);
  Future<void> clearData();
}
