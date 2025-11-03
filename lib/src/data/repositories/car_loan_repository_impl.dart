import 'package:fin_calc/src/data/models/car_loan_model.dart';
import 'package:fin_calc/src/data/repositories/car_loan_repository.dart';
import 'package:hive/hive.dart';

class CarLoanRepositoryImpl implements ICarLoanRepository {
  final Box _calculationsBox = Hive.box('calculations');
  final String _dataKey = 'car_loan_data';

  @override
  Future<CarLoanModel?> getInitialData() async {
    final savedData = _calculationsBox.get(_dataKey);
    return savedData as CarLoanModel?;
  }

  @override
  Future<void> saveData(CarLoanModel data) async {
    await _calculationsBox.put(_dataKey, data);
  }

  @override
  Future<void> clearData() async {
    await _calculationsBox.delete(_dataKey);
  }
}
