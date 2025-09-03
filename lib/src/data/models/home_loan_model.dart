import 'package:equatable/equatable.dart'; 
import 'package:hive/hive.dart';

part 'home_loan_model.g.dart';

@HiveType(typeId: 0)
class HomeLoanModel extends Equatable { 
  @HiveField(0)
  final double? housePrice;

  @HiveField(1)
  final double? downPayment;

  @HiveField(2)
  final double? interestRate;

  @HiveField(3)
  final int? loanTermYears;

  @HiveField(4)
  final double? monthlyPayment;

  const HomeLoanModel({ 
    this.housePrice,
    this.downPayment,
    this.interestRate,
    this.loanTermYears,
    this.monthlyPayment,
  });

  @override
  List<Object?> get props => [ 
        housePrice,
        downPayment,
        interestRate,
        loanTermYears,
        monthlyPayment,
      ];
}