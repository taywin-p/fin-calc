import 'package:fin_calc/src/data/models/car_loan_model_v2.dart';

abstract class ICarLoanRepository {
  //เปลี่ยน Model เป็น V2
  Future<CarLoanModelV2?> getInitialData();

  // เปลี่ยน Model เป็น V2
  Future<void> saveData(CarLoanModelV2 data);

  Future<void> clearData();
}
