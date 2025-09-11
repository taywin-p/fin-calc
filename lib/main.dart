import 'package:fin_calc/src/data/models/home_loan_model.dart';
import 'package:fin_calc/src/data/models/savings_model.dart';
import 'package:fin_calc/src/page/main_dashboard/main_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Delete existing box to clear old data with conflicting typeIds
  await Hive.deleteBoxFromDisk('calculations');

  Hive.registerAdapter(HomeLoanModelAdapter());
  Hive.registerAdapter(PaymentScheduleItemAdapter());
  Hive.registerAdapter(SavingsModelAdapter());
  Hive.registerAdapter(SavingsScheduleItemAdapter());

  await Hive.openBox('calculations');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'FinCalc', home: const MainDashboardPage());
  }
}
