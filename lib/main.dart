import 'package:fin_calc/src/data/models/home_loan_model.dart';
import 'package:fin_calc/src/data/models/savings_model.dart';
import 'package:fin_calc/src/data/models/investment_model.dart';
import 'package:fin_calc/src/data/models/retirement_model.dart';
import 'package:fin_calc/src/data/models/car_loan_model.dart';
import 'package:fin_calc/src/data/models/car_loan_model_v2.dart'; // 👈 1. Import V2
import 'package:fin_calc/src/page/main_dashboard/main_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 1. เตรียม Hive
  await Hive.initFlutter();
  // 2. ลงทะเบียน Type Adapters (เพื่อแปลง dart Object ↔ Binary)
  Hive.registerAdapter(HomeLoanModelAdapter());
  Hive.registerAdapter(PaymentScheduleItemAdapter());
  Hive.registerAdapter(SavingsModelAdapter());
  Hive.registerAdapter(SavingsScheduleItemAdapter());
  Hive.registerAdapter(InvestmentModelAdapter());
  Hive.registerAdapter(InvestmentTypeAdapter());
  Hive.registerAdapter(InvestmentScheduleItemAdapter());
  Hive.registerAdapter(RetirementModelAdapter());

  Hive.registerAdapter(CarLoanModelAdapter()); //  V1 (typeId: 11)
  Hive.registerAdapter(CarLoanModelV2Adapter()); //  ลงทะเบียน Adapter V2 (typeId: 13)
  Hive.registerAdapter(CarLoanScheduleItemAdapter()); // (typeId: 12)

  // 3. เปิด Box (สร้าง/เปิดไฟล์ในเครื่อง)
  await Hive.openBox('calculations');

  // 7. เรียกใช้ฟังก์ชัน Migration
  await _runHiveMigration();

  runApp(const MyApp());
}

// 3. สร้างฟังก์ชัน _runHiveMigration()
Future<void> _runHiveMigration() async {
  var box = Hive.box('calculations');
  // 4. Key V1 (จาก repo V1)
  const oldKey = 'car_loan_data';
  // 5. Key V2 (ที่เราจะใช้ใน repo V2)
  const newKey = 'car_loan_data_v2';

  final oldData = box.get(oldKey);

  // 4. ตรวจสอบว่ามีข้อมูล V1 อยู่หรือไม่
  if (oldData != null && oldData is CarLoanModel) {
    // 6. เพิ่ม LOG สำหรับ Demo
    print('===== HIVE MIGRATION: V1 -> V2 =====');
    print('พบข้อมูล V1 (CarLoanModel) ที่ Key: $oldKey');
    print('กำลังแปลงข้อมูล... (V1 loanTermYears: ${oldData.loanTermYears})');

    // 5. แปลงข้อมูล V1 -> V2
    final v2Data = CarLoanModelV2(
      carPrice: oldData.carPrice,
      downPayment: oldData.downPayment,
      interestRate: oldData.interestRate,

      // int (7) -> String ("7 ปี")
      loanTermYears: (oldData.loanTermYears != null) ? "${oldData.loanTermYears} ปี" : null,

      monthlyPayment: oldData.monthlyPayment,
      loanAmount: oldData.loanAmount,
      totalInterest: oldData.totalInterest,
      totalPayment: oldData.totalPayment,
      calculatedDate: oldData.calculatedDate,
    );

    // 6. เพิ่ม LOG สำหรับ Demo
    print('แปลงสำเร็จ! (V2 loanTermYears: ${v2Data.loanTermYears})');

    // 5. บันทึก V2 (ด้วย Key ใหม่) และลบ V1 (ด้วย Key เก่า)
    await box.put(newKey, v2Data);
    print('บันทึกข้อมูล V2 (CarLoanModelV2) ที่ Key: $newKey สำเร็จ');

    await box.delete(oldKey);
    print('ลบข้อมูล V1 ที่ Key: $oldKey ทิ้งแล้ว');
    print('====================================');
  } else {
    //  6. เพิ่ม LOG สำหรับ Demo
    print('===== HIVE MIGRATION: ไม่พบข้อมูล V1 (CarLoanModel) =====');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'FinCalc', home: const MainDashboardPage());
  }
}
