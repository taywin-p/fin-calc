import 'package:fin_calc/src/data/models/car_loan_model.dart';
import 'package:fin_calc/src/data/repositories/car_loan_repository.dart';
import 'package:hive/hive.dart';

class CarLoanRepositoryImpl implements ICarLoanRepository {
  final Box _calculationsBox = Hive.box('calculations');
  final String _dataKey = 'car_loan_data';

  @override
  Future<CarLoanModel?> getInitialData() async {
    final savedData = _calculationsBox.get(_dataKey);

    // 🔍 V3 Debug: ดูว่า carModelName เป็น null หรือไม่
    if (savedData is CarLoanModel) {
      print(' V3: โหลดข้อมูลสำเร็จ');
      print('   - carPrice: ${savedData.carPrice}');
      print('   - loanTermYears: ${savedData.loanTermYears}');
      print('   - carModelName: ${savedData.carModelName}'); // จะเป็น null ถ้าเป็นข้อมูล V1
      if (savedData.carModelName == null) {
        print('   carModelName = null (ข้อมูล V1 เก่า - Backward Compatible!)');

        //ถ้าต้องการ assign default value สำหรับข้อมูล V1 เก่า:
        // final migratedData = savedData.copyWith(
        //   carModelName: 'ไม่ระบุรุ่นรถ',  // Default value
        // );
        // await _calculationsBox.put(_dataKey, migratedData);  // บันทึกกลับ
        // return migratedData;
      }
    }

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
