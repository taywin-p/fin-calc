import 'package:fin_calc/src/data/repositories/home_loan_repository_impl.dart';
import 'package:fin_calc/src/page/home_loan_calculator/home_loan_calculator.dart';
import 'package:fin_calc/src/page/home_loan_calculator_details/home_loan_calculator_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'bloc/home_loan_calculator_cubit.dart';

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

class HomeLoanCalculatorPage extends StatelessWidget {
  const HomeLoanCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeLoanCalculatorCubit(repository: HomeLoanRepositoryImpl()),
      child: const HomeLoanCalculatorView(),
    );
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
    // ซ่อน keyboard ก่อนคำนวณ
    FocusScope.of(context).unfocus();
    
    context.read<HomeLoanCalculatorCubit>().calculate(
      housePrice: _extractNumericValue(_housePriceController.text),
      downPayment: _extractNumericValue(_downPaymentController.text),
      interestRate: _interestRateController.text,
      loanTermYears: _loanTermYearsController.text,
    );
  }

  void _clearData() {
    // ซ่อน keyboard ก่อน reset
    FocusScope.of(context).unfocus();
    
    context.read<HomeLoanCalculatorCubit>().clear();
    _housePriceController.clear();
    _downPaymentController.clear();
    _interestRateController.clear();
    _loanTermYearsController.clear();
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
            child: BlocListener<HomeLoanCalculatorCubit, HomeLoanCalculatorState>(
            listener: (context, state) {
              if (state is HomeLoanCalculatorLoaded) {
                final calc = state.calculation;
                final formatter = NumberFormat('#,###');
                if (calc.housePrice != null && calc.housePrice! > 0) {
                  _housePriceController.text = formatter.format(calc.housePrice!.toInt());
                }
                if (calc.downPayment != null && calc.downPayment! > 0) {
                  _downPaymentController.text = formatter.format(calc.downPayment!.toInt());
                }
                if (calc.interestRate != null && calc.interestRate! > 0) {
                  _interestRateController.text = calc.interestRate!.toString();
                }
                if (calc.loanTermYears != null && calc.loanTermYears! > 0) {
                  _loanTermYearsController.text = calc.loanTermYears!.toString();
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
                              'สินเชื่อบ้าน',
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
                        child: const Icon(Icons.home_work_rounded, color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                ),

                // Spacing between AppBar and Content
                const SizedBox(height: 24),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        _buildInputSection(),
                        const SizedBox(height: 24),
                        _buildActionButtons(),
                        const SizedBox(height: 24),
                        BlocBuilder<HomeLoanCalculatorCubit, HomeLoanCalculatorState>(
                          builder: (context, state) {
                            if (state is HomeLoanCalculatorLoaded) {
                              if (state.calculation.monthlyPayment == null || state.calculation.monthlyPayment == 0) {
                                return const SizedBox.shrink();
                              }
                              return _buildSummarySection(state.calculation);
                            }
                            return const CircularProgressIndicator();
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
            controller: _housePriceController,
            labelText: 'ราคาบ้าน',
            suffixText: 'บาท',
            icon: Icons.home_outlined,
            inputFormatters: [NumberTextInputFormatter()],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _downPaymentController,
            labelText: 'เงินดาวน์',
            suffixText: 'บาท',
            icon: Icons.money_outlined,
            inputFormatters: [NumberTextInputFormatter()],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _interestRateController,
            labelText: 'อัตราดอกเบี้ยเงินกู้',
            suffixText: '% ต่อปี',
            icon: Icons.percent_outlined,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _loanTermYearsController,
            labelText: 'ระยะเวลากู้',
            suffixText: 'ปี',
            icon: Icons.schedule_outlined,
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
                icon: const Icon(Icons.refresh_rounded, color: Colors.white70, size: 18),
                label: const Text(
                  'รีเซ็ต',
                  style: TextStyle(color: Colors.white70, fontSize: 15, fontWeight: FontWeight.w500),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1),
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
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF667eea).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
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
        calculation.monthlyPayment != null &&
        calculation.monthlyPayment! > 0 &&
        calculation.loanAmount != null &&
        calculation.totalInterest != null &&
        calculation.totalPayment != null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(color: const Color(0xFF667eea).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
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
            // Monthly Payment Highlight
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text(
                    'ยอดผ่อนรายเดือน',
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, fontWeight: FontWeight.w400),
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
            // Details Grid
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  _buildDetailRow('ราคาบ้าน', '${numberFormat.format(calculation.housePrice ?? 0)} บาท'),
                  _buildDetailRow('เงินดาวน์', '${numberFormat.format(calculation.downPayment ?? 0)} บาท'),
                  _buildDetailRow('เงินกู้', '${numberFormat.format(calculation.loanAmount ?? 0)} บาท'),
                  _buildDetailRow('ดอกเบี้ยรวม', '${numberFormat.format(calculation.totalInterest ?? 0)} บาท'),
                  const Divider(color: Colors.white24, height: 20),
                  _buildDetailRow(
                    'ยอดรวมทั้งสิ้น',
                    '${numberFormat.format(calculation.totalPayment ?? 0)} บาท',
                    isTotal: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Payment Schedule Button
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
                    MaterialPageRoute(builder: (context) => HomeLoanCalculatorDetailsPage(calculation: calculation)),
                  );
                },
                icon: const Icon(Icons.table_rows_rounded, color: Colors.white, size: 18),
                label: const Text(
                  'ดูตารางการผ่อนชำระรายเดือน',
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
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: Colors.white.withOpacity(0.8), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'กรุณากรอกข้อมูลให้ครบถ้วนเพื่อคำนวณผลลัพธ์',
                      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, fontWeight: FontWeight.w400),
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
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: isTotal ? 15 : 14,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
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
