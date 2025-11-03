import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/models/home_loan_model.dart';
import '../../data/services/loan_calculator_service.dart';
import 'bloc/home_loan_calculator_details_cubit.dart';
import 'home_loan_calculator_details_state.dart';

class HomeLoanCalculatorDetailsPage extends StatelessWidget {
  final HomeLoanModel calculation;

  const HomeLoanCalculatorDetailsPage({super.key, required this.calculation});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeLoanCalculatorDetailsCubit(),
      child: _HomeLoanCalculatorDetailsView(calculation: calculation),
    );
  }
}

class _HomeLoanCalculatorDetailsView extends StatelessWidget {
  final HomeLoanModel calculation;

  const _HomeLoanCalculatorDetailsView({required this.calculation});

  @override
  Widget build(BuildContext context) {
    // recheck if data is complete before building the schedule
    if (calculation.loanAmount == null ||
        calculation.monthlyPayment == null ||
        calculation.interestRate == null ||
        calculation.loanTermYears == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F0F23),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A1A2E),
          title: const Text('ตารางการผ่อนชำระ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
        ),
        body: const Center(
          child: Text(
            'ข้อมูลไม่ครบถ้วน\nไม่สามารถสร้างตารางการผ่อนชำระได้',
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final schedule = LoanCalculatorService.generatePaymentSchedule(
      loanAmount: calculation.loanAmount!,
      monthlyPayment: calculation.monthlyPayment!,
      monthlyInterestRate: (calculation.interestRate! / 100) / 12,
      numberOfPayments: calculation.loanTermYears! * 12,
    );

    final numberFormat = NumberFormat('#,##0.00');

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F0F23), Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
        ),
        child: SafeArea(
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
                      child: Text(
                        'ตารางการผ่อนชำระ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.table_rows_rounded, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),

              // Spacing between AppBar and Content
              const SizedBox(height: 24),

              Expanded(
                child: Column(
                  children: [
                    // Summary Section
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF667eea).withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with toggle button
                          BlocBuilder<HomeLoanCalculatorDetailsCubit, HomeLoanCalculatorDetailsState>(
                            builder: (context, state) {
                              final cubit = context.read<HomeLoanCalculatorDetailsCubit>();
                              return GestureDetector(
                                onTap: () {
                                  cubit.toggleSummaryVisibility();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'สรุป',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        shadows: [Shadow(offset: Offset(0, 2), blurRadius: 4, color: Colors.black45)],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        cubit.isSummaryVisible
                                            ? Icons.keyboard_arrow_up_rounded
                                            : Icons.keyboard_arrow_down_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          // เนื้อหาส่วนสรุป (แสดง/ซ่อนตาม state)
                          BlocBuilder<HomeLoanCalculatorDetailsCubit, HomeLoanCalculatorDetailsState>(
                            builder: (context, state) {
                              final cubit = context.read<HomeLoanCalculatorDetailsCubit>();
                              if (!cubit.isSummaryVisible) return const SizedBox.shrink();

                              return Column(
                                children: [
                                  const SizedBox(height: 16),
                                  _buildSummaryRow(
                                    'ราคาบ้าน',
                                    '${numberFormat.format(calculation.housePrice ?? 0)} บาท',
                                  ),
                                  _buildSummaryRow(
                                    'เงินดาวน์',
                                    '${numberFormat.format(calculation.downPayment ?? 0)} บาท',
                                  ),
                                  _buildSummaryRow(
                                    'เงินกู้',
                                    '${numberFormat.format(calculation.loanAmount ?? 0)} บาท',
                                  ),
                                  _buildSummaryRow(
                                    'ดอกเบี้ยเงินกู้',
                                    '${numberFormat.format(calculation.totalInterest ?? 0)} บาท',
                                  ),
                                  _buildSummaryRow(
                                    'เงินกู้รวมดอกเบี้ย',
                                    '${numberFormat.format(calculation.totalPayment ?? 0)} บาท',
                                  ),
                                  const Divider(color: Colors.white54, height: 20),
                                  _buildSummaryRow(
                                    'ผ่อนเดือนละ',
                                    '${numberFormat.format(calculation.monthlyPayment ?? 0)} บาท',
                                    isHighlight: true,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // Table Section
                    // Table Header
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)],
                        ),
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                      ),
                      child: const Row(
                        children: [
                          Expanded(flex: 1, child: _TableHeader('งวด')),
                          Expanded(flex: 2, child: _TableHeader('ค่างวด')),
                          Expanded(flex: 2, child: _TableHeader('ดอกเบี้ย')),
                          Expanded(flex: 2, child: _TableHeader('เงินต้น')),
                          Expanded(flex: 2, child: _TableHeader('คงเหลือ')),
                        ],
                      ),
                    ),

                    // Table Data
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A2E).withOpacity(0.7),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                        ),
                        child: ListView.builder(
                          itemCount: schedule.length,
                          itemBuilder: (context, index) {
                            final item = schedule[index];
                            final isEven = index % 2 == 0;

                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                              decoration: BoxDecoration(
                                color: isEven ? Colors.white.withOpacity(0.05) : Colors.transparent,
                              ),
                              child: Row(
                                children: [
                                  Expanded(flex: 1, child: _TableCell(item.month.toString())),
                                  Expanded(flex: 2, child: _TableCell(numberFormat.format(item.payment))),
                                  Expanded(flex: 2, child: _TableCell(numberFormat.format(item.interest))),
                                  Expanded(flex: 2, child: _TableCell(numberFormat.format(item.principal))),
                                  Expanded(flex: 2, child: _TableCell(numberFormat.format(item.remainingBalance))),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: isHighlight ? 16 : 14,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
              shadows: const [Shadow(offset: Offset(0, 1), blurRadius: 3, color: Colors.black38)],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: isHighlight ? 16 : 14,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
              shadows: const [Shadow(offset: Offset(0, 1), blurRadius: 3, color: Colors.black38)],
            ),
          ),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String text;

  const _TableHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;

  const _TableCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(color: Colors.white, fontSize: 13), textAlign: TextAlign.center);
  }
}
