import 'package:fin_calc/src/data/models/retirement_model.dart';

abstract class IRetirementRepository {
  Future<RetirementModel?> getInitialData();
  Future<void> saveData(RetirementModel data);
  Future<void> clearData();
}
