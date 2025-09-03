// lib/src/page/home_loan_calculator/home_loan_calculator_page.dart
import 'package:fin_calc/src/page/home_loan_calculator/home_loan_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/home_loan_calculator_cubit.dart';

class HomeLoanCalculatorPage extends StatelessWidget {
  const HomeLoanCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => HomeLoanCalculatorCubit(), child: const HomeLoanCalculatorView());
  }
}

class HomeLoanCalculatorView extends StatefulWidget {
  const HomeLoanCalculatorView({super.key});

  @override
  State<HomeLoanCalculatorView> createState() => _HomeLoanCalculatorViewState();
}

class _HomeLoanCalculatorViewState extends State<HomeLoanCalculatorView> {
  final _housePriceController = TextEditingController();
  final _downPaymentController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _loanTermYearsController = TextEditingController();

  @override
  void dispose() {
    _housePriceController.dispose();
    _downPaymentController.dispose();
    _interestRateController.dispose();
    _loanTermYearsController.dispose();
    super.dispose();
  }

  void _submitCalculation() {
    context.read<HomeLoanCalculatorCubit>().calculate(
      housePrice: _housePriceController.text,
      downPayment: _downPaymentController.text,
      interestRate: _interestRateController.text,
      loanTermYears: _loanTermYearsController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('คำนวณผ่อนบ้าน (New Structure)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocListener<HomeLoanCalculatorCubit, HomeLoanCalculatorState>(
        listener: (context, state) {
          if (state is HomeLoanCalculatorLoaded) {
            final calc = state.calculation;
            _housePriceController.text = calc.housePrice?.toString() ?? '0';
            _downPaymentController.text = calc.downPayment?.toString() ?? '0';
            _interestRateController.text = calc.interestRate?.toString() ?? '0';
            _loanTermYearsController.text = calc.loanTermYears?.toString() ?? '0';
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTextField(controller: _housePriceController, labelText: 'ราคาบ้าน'),
              const SizedBox(height: 16),
              _buildTextField(controller: _downPaymentController, labelText: 'เงินดาวน์'),
              const SizedBox(height: 16),
              _buildTextField(controller: _interestRateController, labelText: 'อัตราดอกเบี้ย'),
              const SizedBox(height: 16),
              _buildTextField(controller: _loanTermYearsController, labelText: 'ระยะเวลากู้'),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _submitCalculation, child: const Text('คำนวณ')),
              const SizedBox(height: 24),
              const Divider(),
              // BlocBuilder จะสร้าง UI ตาม State ที่เปลี่ยนไป
              BlocBuilder<HomeLoanCalculatorCubit, HomeLoanCalculatorState>(
                builder: (context, state) {
                  if (state is HomeLoanCalculatorLoaded) {
                    if (state.calculation.monthlyPayment == null || state.calculation.monthlyPayment == 0) {
                      return const SizedBox.shrink();
                    }
                    return _buildSummary(state.calculation.monthlyPayment!);
                  }
                  return const CircularProgressIndicator(); 
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummary(double monthlyPayment) {
    return Column(
      children: [
        const Text('สรุปผลการคำนวณ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('ยอดผ่อนชำระต่อเดือน: ${monthlyPayment.toStringAsFixed(2)} บาท'),
      ],
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String labelText}) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: labelText, border: const OutlineInputBorder()),
    );
  }
}
