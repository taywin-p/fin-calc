import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:fin_calc/src/data/repositories/retirement_repository_impl.dart';
import 'package:fin_calc/src/page/retirement_calculator/bloc/retirement_calculator_cubit.dart';
import 'package:fin_calc/src/page/retirement_calculator_details/retirement_calculator_details.dart';

// Custom number formatter for comma-separated numbers
class NumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digits
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.isEmpty) {
      return const TextEditingValue();
    }

    // Format with commas
    final formatter = NumberFormat('#,###');
    String formatted = formatter.format(int.parse(digitsOnly));

    return TextEditingValue(text: formatted, selection: TextSelection.collapsed(offset: formatted.length));
  }
}

// Helper method to extract numeric value from formatted text
String _extractNumericValue(String formattedText) {
  return formattedText.replaceAll(',', '');
}

class RetirementCalculatorPage extends StatelessWidget {
  const RetirementCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RetirementCalculatorCubit(repository: RetirementRepositoryImpl()),
      child: const RetirementCalculatorView(),
    );
  }
}

class RetirementCalculatorView extends StatefulWidget {
  const RetirementCalculatorView({super.key});

  @override
  State<RetirementCalculatorView> createState() => _RetirementCalculatorViewState();
}

class _RetirementCalculatorViewState extends State<RetirementCalculatorView> {
  final _currentAgeController = TextEditingController();
  final _retirementAgeController = TextEditingController();
  final _currentSavingsController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _inflationRateController = TextEditingController();
  final _lifeExpectancyController = TextEditingController();
  final _monthlyExpensesController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _currentAgeController.dispose();
    _retirementAgeController.dispose();
    _currentSavingsController.dispose();
    _interestRateController.dispose();
    _inflationRateController.dispose();
    _lifeExpectancyController.dispose();
    _monthlyExpensesController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _submitCalculation() {
    FocusScope.of(context).unfocus();

    context.read<RetirementCalculatorCubit>().calculate(
      currentAge: _currentAgeController.text,
      retirementAge: _retirementAgeController.text,
      currentSavings: _extractNumericValue(_currentSavingsController.text),
      annualInterestRate: _interestRateController.text,
      inflationRate: _inflationRateController.text,
      lifeExpectancy: _lifeExpectancyController.text,
      monthlyExpenses: _extractNumericValue(_monthlyExpensesController.text),
    );
  }

  void _clearData() {
    FocusScope.of(context).unfocus();

    context.read<RetirementCalculatorCubit>().clear();
    _currentAgeController.clear();
    _retirementAgeController.clear();
    _currentSavingsController.clear();
    _interestRateController.clear();
    _inflationRateController.clear();
    _lifeExpectancyController.clear();
    _monthlyExpensesController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0F0F23), Color(0xFF1A1A2E), Color(0xFF16213E)],
            ),
          ),
          child: SafeArea(
            child: BlocListener<RetirementCalculatorCubit, RetirementCalculatorState>(
              listener: (context, state) {
                if (state is RetirementCalculatorLoaded) {
                  final calc = state.calculation;
                  final formatter = NumberFormat('#,###');
                  if (calc.currentAge != null) {
                    _currentAgeController.text = calc.currentAge.toString();
                  }
                  if (calc.retirementAge != null) {
                    _retirementAgeController.text = calc.retirementAge.toString();
                  }
                  if (calc.currentSavings != null && calc.currentSavings! >= 0) {
                    _currentSavingsController.text = formatter.format(calc.currentSavings!.toInt());
                  }
                  if (calc.annualInterestRate != null && calc.annualInterestRate! >= 0) {
                    _interestRateController.text = calc.annualInterestRate!.toString();
                  }
                  if (calc.inflationRate != null && calc.inflationRate! >= 0) {
                    _inflationRateController.text = calc.inflationRate!.toString();
                  }
                  if (calc.lifeExpectancy != null) {
                    _lifeExpectancyController.text = calc.lifeExpectancy.toString();
                  }
                  if (calc.monthlyExpenses != null && calc.monthlyExpenses! > 0) {
                    _monthlyExpensesController.text = formatter.format(calc.monthlyExpenses!.toInt());
                  }
                }
              },
              child: Column(
                children: [
                  // AppBar
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white.withOpacity(0.25), Colors.white.withOpacity(0.1)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 8)),
                        BoxShadow(color: Colors.white.withOpacity(0.05), blurRadius: 8, offset: const Offset(-2, -2)),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Back Button
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                            ),
                            child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Title Section
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'วางแผนเกษียณ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Icon
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.beach_access_outlined, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          _buildInputSection(),
                          const SizedBox(height: 24),
                          _buildActionButtons(),
                          const SizedBox(height: 24),
                          BlocBuilder<RetirementCalculatorCubit, RetirementCalculatorState>(
                            builder: (context, state) {
                              if (state is RetirementCalculatorLoaded) {
                                return _buildSummarySection(state.calculation);
                              } else if (state is RetirementCalculatorError) {
                                return _buildErrorSection(state.message);
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E).withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _currentAgeController,
                  labelText: 'อายุปัจจุบัน',
                  suffixText: 'ปี',
                  icon: Icons.person_outline,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: _retirementAgeController,
                  labelText: 'อายุที่จะเกษียณ',
                  suffixText: 'ปี',
                  icon: Icons.flag_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _currentSavingsController,
            labelText: 'เงินเก็บเดิม',
            suffixText: 'บาท',
            icon: Icons.account_balance_wallet_outlined,
            inputFormatters: [NumberTextInputFormatter()],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _interestRateController,
                  labelText: 'ดอกเบี้ยรับ',
                  suffixText: '% ต่อปี',
                  icon: Icons.percent_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: _inflationRateController,
                  labelText: 'เงินเฟ้อ',
                  suffixText: '% ต่อปี',
                  icon: Icons.trending_up_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _lifeExpectancyController,
            labelText: 'คาดว่าจะมีอายุถึง',
            suffixText: 'ปี',
            icon: Icons.favorite_outline,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _monthlyExpensesController,
            labelText: 'ค่าใช้จ่ายต่อเดือนหลังเกษียณ (ปัจจุบัน)',
            suffixText: 'บาท',
            icon: Icons.shopping_cart_outlined,
            inputFormatters: [NumberTextInputFormatter()],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String suffixText,
    required IconData icon,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
        suffixText: suffixText,
        suffixStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.7), size: 20),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF667EEA), width: 2),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 4),
              child: TextButton.icon(
                onPressed: _clearData,
                icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
                label: const Text(
                  'รีเซ็ต',
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF2D3748),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: const Color(0xFFf5576c).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _submitCalculation,
                icon: const Icon(Icons.calculate_rounded, color: Colors.white, size: 18),
                label: const Text(
                  'คำนวณผลลัพธ์',
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(calculation) {
    final numberFormat = NumberFormat('#,##0');
    final decimalFormat = NumberFormat('#,##0.00');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(color: const Color(0xFFf5576c).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.analytics_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'สรุปผลการวางแผนเกษียณ',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Timeline Highlight
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTimelineItem(
                  label: 'ระยะเวลา\nก่อนเกษียณ',
                  value: '${calculation.yearsUntilRetirement ?? 0} ปี',
                ),
                Container(width: 1, height: 40, color: Colors.white.withOpacity(0.4)),
                _buildTimelineItem(
                  label: 'ใช้เงิน\nหลังเกษียณ',
                  value: '${calculation.yearsInRetirement ?? 0} ปี',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Expenses Comparison
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Text(
                  'ค่าใช้จ่ายรายเดือน',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  'ค่าใช้จ่าย ณ ปัจจุบัน',
                  '${numberFormat.format(calculation.currentMonthlyExpenses ?? 0)} บาท/เดือน',
                ),
                _buildDetailRow(
                  'ค่าใช้จ่าย ณ วันเกษียณ',
                  '${numberFormat.format(calculation.retirementMonthlyExpenses ?? 0)} บาท/เดือน',
                  highlight: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Savings Required
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.4)),
            ),
            child: Column(
              children: [
                const Text(
                  'เงินที่ต้องเตรียม',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  'ต้องมีเงินเก็บ ณ วันเกษียณ',
                  '${decimalFormat.format(calculation.totalRetirementNeeded ?? 0)} บาท',
                  isTotal: true,
                ),
                const Divider(color: Colors.white54, height: 20),
                _buildDetailRow(
                  'เงินเก็บเดิม (เติบโตด้วยดอกเบี้ย)',
                  '${decimalFormat.format(calculation.currentSavingsGrowth ?? 0)} บาท',
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  'ต้องเก็บเพิ่มอีก (รวม)',
                  '${decimalFormat.format(calculation.additionalSavingsNeeded ?? 0)} บาท',
                  highlight: true,
                ),
                const Divider(color: Colors.white54, height: 20),
                _buildDetailRow(
                  'ต้องเก็บเพิ่มอีก (ต่อเดือน)',
                  '${numberFormat.format(calculation.monthlySavingsNeeded ?? 0)} บาท/เดือน',
                  isTotal: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Details Button
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RetirementCalculatorDetailsPage(calculation: calculation),
                  ),
                );
              },
              icon: const Icon(Icons.table_rows_rounded, color: Colors.white, size: 18),
              label: const Text(
                'ดูรายละเอียดเพิ่มเติม',
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({required String label, required String value}) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false, bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: isTotal ? 15 : 14,
                fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              color: highlight ? Colors.yellow : Colors.white,
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorSection(String message) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
