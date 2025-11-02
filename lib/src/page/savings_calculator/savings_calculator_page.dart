import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:fin_calc/src/data/repositories/savings_repository_impl.dart';
import 'package:fin_calc/src/page/savings_calculator/bloc/savings_calculator_cubit.dart';
import 'package:fin_calc/src/data/services/savings_calculator_service.dart';
import 'package:fin_calc/src/page/savings_calculator_details/savings_calculator_details.dart';
import 'widgets/savings_summary_chart_widget_new.dart';

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

class SavingsCalculatorPage extends StatelessWidget {
  const SavingsCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SavingsCalculatorCubit(repository: SavingsRepositoryImpl()),
      child: const SavingsCalculatorView(),
    );
  }
}

class SavingsCalculatorView extends StatefulWidget {
  const SavingsCalculatorView({super.key});

  @override
  State<SavingsCalculatorView> createState() => _SavingsCalculatorViewState();
}

class _SavingsCalculatorViewState extends State<SavingsCalculatorView> {
  final _savingsGoalController = TextEditingController();
  final _currentSavingsController = TextEditingController();
  final _monthlyDepositController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _scrollController = ScrollController(); // เพิ่ม ScrollController

  @override
  void dispose() {
    _savingsGoalController.dispose();
    _currentSavingsController.dispose();
    _monthlyDepositController.dispose();
    _interestRateController.dispose();
    _scrollController.dispose(); // ปิด ScrollController
    super.dispose();
  }

  void _submitCalculation() {
    // ซ่อน keyboard ก่อนคำนวณ
    FocusScope.of(context).unfocus();

    context.read<SavingsCalculatorCubit>().calculate(
      savingsGoal: _extractNumericValue(_savingsGoalController.text),
      currentSavings: _extractNumericValue(_currentSavingsController.text),
      monthlyDeposit: _extractNumericValue(_monthlyDepositController.text),
      interestRate: _interestRateController.text,
    );
  }

  void _clearData() {
    // ซ่อน keyboard ก่อน reset
    FocusScope.of(context).unfocus();

    context.read<SavingsCalculatorCubit>().clear();
    _savingsGoalController.clear();
    _currentSavingsController.clear();
    _monthlyDepositController.clear();
    _interestRateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // ซ่อน keyboard เมื่อแตะที่พื้นที่ว่าง
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
            child: BlocListener<SavingsCalculatorCubit, SavingsCalculatorState>(
              listener: (context, state) {
                if (state is SavingsCalculatorLoaded) {
                  final calc = state.calculation;
                  final formatter = NumberFormat('#,###');
                  if (calc.savingsGoal != null && calc.savingsGoal! > 0) {
                    _savingsGoalController.text = formatter.format(calc.savingsGoal!.toInt());
                  }
                  if (calc.currentSavings != null && calc.currentSavings! >= 0) {
                    _currentSavingsController.text = formatter.format(calc.currentSavings!.toInt());
                  }
                  if (calc.monthlyDeposit != null && calc.monthlyDeposit! >= 0) {
                    _monthlyDepositController.text = formatter.format(calc.monthlyDeposit!.toInt());
                  }
                  if (calc.interestRate != null && calc.interestRate! >= 0) {
                    _interestRateController.text = calc.interestRate!.toString();
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'เป้าหมายการออม',
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
                          child: const Icon(Icons.savings_outlined, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ),

                  // Spacing between AppBar and Content
                  const SizedBox(height: 24),

                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController, // เพิ่ม controller
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          _buildInputSection(),
                          const SizedBox(height: 24),
                          _buildActionButtons(),
                          const SizedBox(height: 24),
                          BlocBuilder<SavingsCalculatorCubit, SavingsCalculatorState>(
                            builder: (context, state) {
                              if (state is SavingsCalculatorLoaded) {
                                if (state.calculation.timeToGoalMonths == null ||
                                    state.calculation.timeToGoalMonths! <= 0) {
                                  return const SizedBox.shrink();
                                }
                                return _buildSummarySection(state.calculation);
                              } else if (state is SavingsCalculatorError) {
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
            ), // ปิด BlocListener
          ), // ปิด SafeArea
        ), // ปิด GestureDetector
      ), // ปิด Container
    ); // ปิด Scaffold
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
          _buildTextField(
            controller: _savingsGoalController,
            labelText: 'เป้าหมายการออม',
            suffixText: 'บาท',
            icon: Icons.flag_outlined,
            inputFormatters: [NumberTextInputFormatter()],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _currentSavingsController,
            labelText: 'เงินออมปัจจุบัน',
            suffixText: 'บาท',
            icon: Icons.account_balance_wallet_outlined,
            inputFormatters: [NumberTextInputFormatter()],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _monthlyDepositController,
            labelText: 'เงินออมรายเดือน',
            suffixText: 'บาท',
            icon: Icons.add_card_outlined,
            inputFormatters: [NumberTextInputFormatter()],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _interestRateController,
            labelText: 'อัตราดอกเบี้ยเงินฝาก',
            suffixText: '% ต่อปี',
            icon: Icons.percent_outlined,
          ),
        ],
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
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF667EEA).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
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
    final numberFormat = NumberFormat('#,##0.00');
    final hasValidCalculation =
        calculation.timeToGoalMonths != null &&
        calculation.timeToGoalMonths! > 0 &&
        calculation.finalAmount != null &&
        calculation.totalDeposits != null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(color: const Color(0xFF667EEA).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
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
                'ผลการคำนวณ',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (hasValidCalculation) ...[
            // Progress Bar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.4)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ความคืบหน้า',
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${SavingsCalculatorService.calculateProgress(calculation.currentSavings ?? 0, calculation.savingsGoal ?? 1).toStringAsFixed(1)}%',
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value:
                        SavingsCalculatorService.calculateProgress(
                          calculation.currentSavings ?? 0,
                          calculation.savingsGoal ?? 1,
                        ) /
                        100,
                    backgroundColor: Colors.white.withOpacity(0.4),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Time to Goal Highlight
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.4)),
              ),
              child: Column(
                children: [
                  const Text(
                    'เวลาที่ต้องใช้ถึงเป้าหมาย',
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    SavingsCalculatorService.formatTimeToGoal(calculation.timeToGoalMonths ?? 0),
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  if (calculation.goalAchievementDate != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'วันที่ถึงเป้าหมาย: ${DateFormat('dd/MM/yyyy').format(calculation.goalAchievementDate!)}',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Details Grid
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  _buildDetailRow('เป้าหมายการออม', '${numberFormat.format(calculation.savingsGoal ?? 0)} บาท'),
                  _buildDetailRow('เงินออมปัจจุบัน', '${numberFormat.format(calculation.currentSavings ?? 0)} บาท'),
                  _buildDetailRow('เงินออมรายเดือน', '${numberFormat.format(calculation.monthlyDeposit ?? 0)} บาท'),
                  _buildDetailRow('เงินฝากรวม', '${numberFormat.format(calculation.totalDeposits ?? 0)} บาท'),
                  _buildDetailRow('ดอกเบี้ยรวม', '${numberFormat.format(calculation.totalInterest ?? 0)} บาท'),
                  const Divider(color: Colors.white54, height: 20),
                  _buildDetailRow(
                    'เงินรวมสุดท้าย',
                    '${numberFormat.format(calculation.finalAmount ?? 0)} บาท',
                    isTotal: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // กราฟแท่งสรุป
            SavingsSummaryChartWidget(
              currentSavings: calculation.currentSavings ?? 0,
              totalDeposits: (calculation.monthlyDeposit ?? 0) * (calculation.timeToGoalMonths ?? 0),
              totalInterest: calculation.totalInterest ?? 0,
              finalAmount: calculation.finalAmount ?? 0,
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
                    MaterialPageRoute(builder: (context) => SavingsCalculatorDetailsPage(calculation: calculation)),
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
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: const Text(
                      'กรุณากรอกข้อมูลให้ครบถ้วนเพื่อคำนวณผลลัพธ์',
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade300, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.red.shade300, fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: isTotal ? 15 : 14,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: isTotal ? 15 : 14,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            ),
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
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: inputFormatters,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
        suffixText: suffixText,
        suffixStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.8)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
      ),
    );
  }
}
