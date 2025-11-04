import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/investment_repository_impl.dart';
import 'bloc/investment_calculator_cubit.dart';
import 'investment_calculator_page.dart';

class InvestmentCalculatorWrapper extends StatelessWidget {
  const InvestmentCalculatorWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InvestmentCalculatorCubit(repository: InvestmentRepositoryImpl()),
      child: const InvestmentCalculatorPage(),
    );
  }
}
