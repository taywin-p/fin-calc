import 'package:hive/hive.dart';


part 'home_loan_model.g.dart'; 

@HiveType(typeId: 0) // typeId ต้องไม่ซ้ำกันในแต่ละ Model
class HomeLoanModel extends HiveObject {

  @HiveField(0)
  final double? housePrice;

  @HiveField(1)
  final double? downPayment;

  @HiveField(2)
  final double? interestRate;

  @HiveField(3)
  final int? loanTermYears;

  // --- ผลลัพธ์การคำนวณ ---
  @HiveField(4)
  final double? monthlyPayment;

  HomeLoanModel({
    this.housePrice,
    this.downPayment,
    this.interestRate,
    this.loanTermYears,
    this.monthlyPayment,
  });
}