import 'package:fin_calc/src/data/models/home_loan_model.dart';
import 'package:fin_calc/src/data/repositories/home_loan_repository.dart';
import 'package:hive/hive.dart';

class HomeLoanRepositoryImpl implements IHomeLoanRepository {
  final _calculationsBox = Hive.box('calculations');
  final String _dataKey = 'home_loan_data';

  @override
  Future<HomeLoanModel?> getInitialData() async {
    final savedData = _calculationsBox.get(_dataKey) as HomeLoanModel?;
    return savedData;
  }

  @override
  Future<void> saveData(HomeLoanModel data) async {
    await _calculationsBox.put(_dataKey, data);
  }

  @override
  Future<void> clearData() async {
    await _calculationsBox.delete(_dataKey);
  }
}