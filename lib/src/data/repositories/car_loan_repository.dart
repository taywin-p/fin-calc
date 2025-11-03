import 'package:fin_calc/src/data/models/car_loan_model.dart';

abstract class ICarLoanRepository {
  Future<CarLoanModel?> getInitialData();
  Future<void> saveData(CarLoanModel data);
  Future<void> clearData();
}
