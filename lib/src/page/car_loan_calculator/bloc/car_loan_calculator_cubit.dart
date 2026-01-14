import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fin_calc/src/data/models/car_loan_model.dart';
import 'package:fin_calc/src/data/models/car_loan_model_v2.dart';

import 'package:fin_calc/src/data/repositories/car_loan_repository.dart';
import 'package:fin_calc/src/data/services/car_loan_calculator_service.dart';

part '../car_loan_calculator_state.dart';

class CarLoanCalculatorCubit extends Cubit<CarLoanCalculatorState> {
  final ICarLoanRepository repository;

  CarLoanCalculatorCubit({required this.repository}) : super(CarLoanCalculatorInitial()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      //Repository ตอนนี้ return V2 
      final savedData = await repository.getInitialData();
      if (savedData != null) {
        //ส่ง V2 ไปให้ UI
        emit(CarLoanCalculatorLoaded(calculation: savedData));
      } else {
        emit(CarLoanCalculatorInitial());
      }
    } catch (e) {
      emit(CarLoanCalculatorError(message: e.toString()));
    }
  }

  Future<void> calculate({
    required String carPrice,
    required String downPayment,
    required String interestRate,
    required String loanTermYears, // รับ "7" (String) จาก UI
  }) async {
    try {
      emit(CarLoanCalculatorLoading());

      // Validate input
      final price = double.tryParse(carPrice);
      final down = double.tryParse(downPayment);
      final rate = double.tryParse(interestRate);

      // UI -> Logic
      // แปล "7" (String) เป็น int 7
      final term = int.tryParse(loanTermYears);

      if (price == null || price <= 0) {
        emit(CarLoanCalculatorError(message: 'กรุณากรอกราคารถให้ถูกต้อง'));
        return;
      }

      if (down == null || down < 0) {
        emit(CarLoanCalculatorError(message: 'กรุณากรอกเงินดาวน์ให้ถูกต้อง'));
        return;
      }

      if (down >= price) {
        emit(CarLoanCalculatorError(message: 'เงินดาวน์ต้องน้อยกว่าราคารถ'));
        return;
      }

      if (rate == null || rate < 0 || rate > 20) {
        emit(CarLoanCalculatorError(message: 'กรุณากรอกอัตราดอกเบี้ยให้ถูกต้อง (0-20%)'));
        return;
      }

      if (term == null || term <= 0 || term > 10) {
        //Validate ด้วย int 7
        emit(CarLoanCalculatorError(message: 'กรุณากรอกระยะเวลาผ่อนให้ถูกต้อง (1-10 ปี)'));
        return;
      }

      // Service ยังคงรับ int 7 (Logic ไม่ต้องเปลี่ยน)
      final calculation = CarLoanCalculatorService.calculateCarLoan(
        carPrice: price,
        downPayment: down,
        interestRate: rate,
        loanTermYears: term, // ส่ง int 7
      );

      // Logic V1 -> Storage V2
      // แปลผลลัพธ์ V1 (CarLoanModel) เป็น V2 (CarLoanModelV2)
      final v2Data = CarLoanModelV2(
        carPrice: calculation.carPrice,
        downPayment: calculation.downPayment,
        interestRate: calculation.interestRate,

        //int (7) -> String ("7 ปี")
        loanTermYears: "${calculation.loanTermYears} ปี",

        monthlyPayment: calculation.monthlyPayment,
        loanAmount: calculation.loanAmount,
        totalInterest: calculation.totalInterest,
        totalPayment: calculation.totalPayment,
        calculatedDate: calculation.calculatedDate,
      );

      //Save V2 ลง DB
      await repository.saveData(v2Data);

      //ส่ง V2 ไปให้ UI
      emit(CarLoanCalculatorLoaded(calculation: v2Data));
    } catch (e) {
      emit(CarLoanCalculatorError(message: 'เกิดข้อผิดพลาดในการคำนวณ: ${e.toString()}'));
    }
  }

  Future<void> clear() async {
    try {
      await repository.clearData();
      emit(CarLoanCalculatorInitial());
    } catch (e) {
      emit(CarLoanCalculatorError(message: e.toString()));
    }
  }
}
