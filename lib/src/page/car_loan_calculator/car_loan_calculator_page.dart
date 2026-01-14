// import 'package:fin_calc/src/page/database_debug/database_debug_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:fin_calc/src/data/repositories/car_loan_repository_impl.dart';
import 'package:fin_calc/src/page/car_loan_calculator/bloc/car_loan_calculator_cubit.dart';
import 'package:fin_calc/src/page/car_loan_calculator_details/car_loan_calculator_details.dart';
import 'package:fin_calc/src/data/models/car_loan_model_v2.dart';

// Custom number formatter
class NumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.isEmpty) return const TextEditingValue();
    final formatter = NumberFormat('#,###');
    String formatted = formatter.format(int.parse(digitsOnly));
    return TextEditingValue(text: formatted, selection: TextSelection.collapsed(offset: formatted.length));
  }
}

String _extractNumericValue(String formattedText) {
  return formattedText.replaceAll(',', '');
}

class CarLoanCalculatorPage extends StatelessWidget {
  const CarLoanCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CarLoanCalculatorCubit(repository: CarLoanRepositoryImpl()),
      child: const CarLoanCalculatorView(),
    );
  }
}

class CarLoanCalculatorView extends StatefulWidget {
  const CarLoanCalculatorView({super.key});

  @override
  State<CarLoanCalculatorView> createState() => _CarLoanCalculatorViewState();
}

class _CarLoanCalculatorViewState extends State<CarLoanCalculatorView> {
  final _carPriceController = TextEditingController();
  final _downPaymentController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _loanTermController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _carPriceController.dispose();
    _downPaymentController.dispose();
    _interestRateController.dispose();
    _loanTermController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _submitCalculation() {
    FocusScope.of(context).unfocus();
    context.read<CarLoanCalculatorCubit>().calculate(
      carPrice: _extractNumericValue(_carPriceController.text),
      downPayment: _extractNumericValue(_downPaymentController.text),
      interestRate: _interestRateController.text,
      loanTermYears: _loanTermController.text,
    );
  }

  void _clearData() {
    FocusScope.of(context).unfocus();
    context.read<CarLoanCalculatorCubit>().clear();
    _carPriceController.clear();
    _downPaymentController.clear();
    _interestRateController.clear();
    _loanTermController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(context, MaterialPageRoute(builder: (context) => const DatabaseDebugScreen()));
      //   },
      //   backgroundColor: const Color(0xFF6C63FF),
      //   child: const Icon(Icons.storage, color: Colors.white),
      // ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0F0F23), Color(0xFF1A1A2E), Color(0xFF16213E)],
            ),
          ),
          child: SafeArea(
            child: BlocListener<CarLoanCalculatorCubit, CarLoanCalculatorState>(
              listener: (context, state) {
                if (state is CarLoanCalculatorLoaded) {
                  final calc = state.calculation;
                  final formatter = NumberFormat('#,###');
                  if (calc.carPrice != null && calc.carPrice! > 0) {
                    _carPriceController.text = formatter.format(calc.carPrice!.toInt());
                  }
                  if (calc.downPayment != null && calc.downPayment! >= 0) {
                    _downPaymentController.text = formatter.format(calc.downPayment!.toInt());
                  }
                  if (calc.interestRate != null && calc.interestRate! >= 0) {
                    _interestRateController.text = calc.interestRate!.toString();
                  }

                  // การแปล V2 -> UI
                  // เราได้รับ "7 ปี" (String) จาก V2
                  if (calc.loanTermYears != null) {
                    // "7 ปี" -> "7"
                    final yearsString = calc.loanTermYears!.replaceAll(' ปี', '');
                    _loanTermController.text = yearsString; // ใส่ "7" ลงในช่อง
                  }
                }
              },
              child: Column(
                children: [
                  _buildAppBar(context),
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
                          BlocBuilder<CarLoanCalculatorCubit, CarLoanCalculatorState>(
                            builder: (context, state) {
                              if (state is CarLoanCalculatorLoaded) {
                                return _buildSummarySection(state.calculation);
                              } else if (state is CarLoanCalculatorError) {
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

  Widget _buildAppBar(BuildContext context) {
    return Container(
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 8))],
      ),
      child: Row(
        children: [
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
          const Expanded(
            child: Text(
              'สินเชื่อรถยนต์',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 0.3),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.directions_car_outlined, color: Colors.white, size: 20),
          ),
        ],
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
          _buildTextField(
            controller: _carPriceController,
            labelText: 'ราคารถ',
            suffixText: 'บาท',
            icon: Icons.directions_car_outlined,
            inputFormatters: [NumberTextInputFormatter()],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _downPaymentController,
            labelText: 'เงินดาวน์',
            suffixText: 'บาท',
            icon: Icons.payment_outlined,
            inputFormatters: [NumberTextInputFormatter()],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _interestRateController,
            labelText: 'อัตราดอกเบี้ย',
            suffixText: '% ต่อปี',
            icon: Icons.percent_outlined,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _loanTermController,
            labelText: 'ระยะเวลาผ่อน',
            suffixText: 'ปี',
            icon: Icons.calendar_today_outlined,
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
                gradient: const LinearGradient(colors: [Color(0xFF4A90E2), Color(0xFF357ABD)]),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF4A90E2).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
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

  // รับ CarLoanModelV2
  Widget _buildSummarySection(CarLoanModelV2 calculation) {
    final numberFormat = NumberFormat('#,##0.00');
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(color: const Color(0xFF4A90E2).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
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
                  'ค่างวดต่อเดือน',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  '${numberFormat.format(calculation.monthlyPayment ?? 0)} บาท',
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                _buildDetailRow('ราคารถ', '${numberFormat.format(calculation.carPrice ?? 0)} บาท'),
                _buildDetailRow('เงินดาวน์', '${numberFormat.format(calculation.downPayment ?? 0)} บาท'),
                _buildDetailRow('จำนวนเงินกู้', '${numberFormat.format(calculation.loanAmount ?? 0)} บาท'),
                _buildDetailRow('ดอกเบี้ยรวม', '${numberFormat.format(calculation.totalInterest ?? 0)} บาท'),
                const Divider(color: Colors.white54, height: 20),
                _buildDetailRow(
                  'ยอดชำระรวมทั้งหมด',
                  '${numberFormat.format(calculation.totalPayment ?? 0)} บาท',
                  isTotal: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
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
                  MaterialPageRoute(builder: (context) => CarLoanCalculatorDetailsPage(calculation: calculation)),
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

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: isTotal ? 15 : 14,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: isTotal ? 15 : 14,
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
