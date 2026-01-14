import 'package:fin_calc/src/data/models/car_loan_model_v2.dart';
import 'package:fin_calc/src/data/repositories/car_loan_repository.dart';
import 'package:hive/hive.dart';

class CarLoanRepositoryImpl implements ICarLoanRepository {
  final Box _calculationsBox = Hive.box('calculations');

  //  เปลี่ยน Key ให้อ่านจาก V2 เท่านั้น
  final String _dataKey = 'car_loan_data_v2';

  @override
  Future<CarLoanModelV2?> getInitialData() async {
    // เปลี่ยน Model
    final savedData = _calculationsBox.get(_dataKey);
    return savedData as CarLoanModelV2?; // 4. เปลี่ยน Model
  }

  @override
  Future<void> saveData(CarLoanModelV2 data) async {
    // เปลี่ยน Model
    await _calculationsBox.put(_dataKey, data);
  }

  @override
  Future<void> clearData() async {
    await _calculationsBox.delete(_dataKey);
  }
}
