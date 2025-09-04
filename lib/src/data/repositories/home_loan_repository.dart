import 'package:fin_calc/src/data/models/home_loan_model.dart';

abstract class IHomeLoanRepository {
  Future<HomeLoanModel?> getInitialData();
  Future<void> saveData(HomeLoanModel data);
}