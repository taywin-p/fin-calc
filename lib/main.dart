import 'package:fin_calc/src/data/models/home_loan_model.dart';
import 'package:fin_calc/src/data/models/savings_model.dart';
import 'package:fin_calc/src/data/models/investment_model.dart';
import 'package:fin_calc/src/data/models/retirement_model.dart';
import 'package:fin_calc/src/data/models/car_loan_model.dart';
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
  Hive.registerAdapter(CarLoanModelAdapter());
  Hive.registerAdapter(CarLoanScheduleItemAdapter());
  // 3. เปิด Box (สร้าง/เปิดไฟล์ในเครื่อง)
  await Hive.openBox('calculations');

  // HiveError "unknown typeId" อีก ให้ uncomment 
  // try {
  //   await Hive.openBox('calculations');
  // } catch (e) {
  //   print('Error: $e');
  //   await Hive.deleteBoxFromDisk('calculations');
  //   await Hive.openBox('calculations');
  //   print('ลบข้อมูลเก่าและสร้าง Box ใหม่สำเร็จ!');
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'FinCalc', home: const MainDashboardPage());
  }
}
