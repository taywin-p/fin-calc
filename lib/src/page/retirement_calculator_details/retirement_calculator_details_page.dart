import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'bloc/retirement_calculator_details_cubit.dart';

class RetirementCalculatorDetailsPage extends StatelessWidget {
  final dynamic calculation;

  const RetirementCalculatorDetailsPage({super.key, required this.calculation});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RetirementCalculatorDetailsCubit()..loadData(calculation),
      child: const RetirementCalculatorDetailsView(),
    );
  }
}

class RetirementCalculatorDetailsView extends StatelessWidget {
  const RetirementCalculatorDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final calculation = context.read<RetirementCalculatorDetailsCubit>().calculation;

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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'รายละเอียดการวางแผนเกษียณ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Text(
                            'ข้อมูลสรุปทั้งหมด',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
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
                      child: const Icon(Icons.insights_rounded, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Summary Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xFFf5576c).withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header with toggle button
                            BlocBuilder<RetirementCalculatorDetailsCubit, RetirementCalculatorDetailsState>(
                              builder: (context, state) {
                                final cubit = context.read<RetirementCalculatorDetailsCubit>();
                                return GestureDetector(
                                  onTap: () {
                                    cubit.toggleSummaryVisibility();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'สรุปการวางแผนเกษียณ',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
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

                            // Summary content
                            BlocBuilder<RetirementCalculatorDetailsCubit, RetirementCalculatorDetailsState>(
                              builder: (context, state) {
                                final cubit = context.read<RetirementCalculatorDetailsCubit>();
                                if (!cubit.isSummaryVisible) return const SizedBox.shrink();

                                return Column(
                                  children: [
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildSummaryItem(
                                            'อายุปัจจุบัน',
                                            '${calculation?.currentAge ?? 0} ปี',
                                            Icons.person_outline,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: _buildSummaryItem(
                                            'อายุเกษียณ',
                                            '${calculation?.retirementAge ?? 0} ปี',
                                            Icons.flag_outlined,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildSummaryItem(
                                            'ระยะเวลาก่อนเกษียณ',
                                            '${calculation?.yearsUntilRetirement ?? 0} ปี',
                                            Icons.schedule_outlined,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: _buildSummaryItem(
                                            'ใช้เงินหลังเกษียณ',
                                            '${calculation?.yearsInRetirement ?? 0} ปี',
                                            Icons.calendar_today_outlined,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    _buildFullWidthSummaryItem(
                                      'อายุคาดหวัง',
                                      '${calculation?.lifeExpectancy ?? 0} ปี',
                                      Icons.favorite_outline,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Input Parameters Card
                      _buildDetailCard(
                        title: 'ข้อมูลที่กรอก',
                        icon: Icons.edit_note_rounded,
                        children: [
                          _buildDetailRow(
                            'เงินเก็บเดิม',
                            '${NumberFormat('#,##0.00').format(calculation?.currentSavings ?? 0)} บาท',
                          ),
                          _buildDetailRow(
                            'ดอกเบี้ยรับต่อปี',
                            '${calculation?.annualInterestRate?.toStringAsFixed(2) ?? '0.00'}%',
                          ),
                          _buildDetailRow(
                            'อัตราเงินเฟ้อต่อปี',
                            '${calculation?.inflationRate?.toStringAsFixed(2) ?? '0.00'}%',
                          ),
                          _buildDetailRow(
                            'ค่าใช้จ่าย ณ ปัจจุบัน',
                            '${NumberFormat('#,##0').format(calculation?.currentMonthlyExpenses ?? 0)} บาท/เดือน',
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Calculated Results Card
                      _buildDetailCard(
                        title: 'ผลการคำนวณ',
                        icon: Icons.calculate_rounded,
                        children: [
                          _buildDetailRow(
                            'ค่าใช้จ่าย ณ วันเกษียณ',
                            '${NumberFormat('#,##0').format(calculation?.retirementMonthlyExpenses ?? 0)} บาท/เดือน',
                            highlight: true,
                          ),
                          const Divider(color: Colors.white38, height: 20),
                          _buildDetailRow(
                            'ต้องมีเงินเก็บ ณ วันเกษียณ',
                            '${NumberFormat('#,##0.00').format(calculation?.totalRetirementNeeded ?? 0)} บาท',
                            isTotal: true,
                          ),
                          const Divider(color: Colors.white38, height: 20),
                          _buildDetailRow(
                            'เงินเก็บเดิม (เติบโตด้วยดอกเบี้ย)',
                            '${NumberFormat('#,##0.00').format(calculation?.currentSavingsGrowth ?? 0)} บาท',
                          ),
                          const SizedBox(height: 8),
                          _buildDetailRow(
                            'ต้องเก็บเพิ่มอีก (รวม)',
                            '${NumberFormat('#,##0.00').format(calculation?.additionalSavingsNeeded ?? 0)} บาท',
                            highlight: true,
                          ),
                          const Divider(color: Colors.white38, height: 20),
                          _buildDetailRow(
                            'ต้องเก็บเพิ่มอีก (ต่อเดือน)',
                            '${NumberFormat('#,##0').format(calculation?.monthlySavingsNeeded ?? 0)} บาท/เดือน',
                            isTotal: true,
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Tips Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A2E).withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 20),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'เคล็ดลับการวางแผนเกษียณ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildTipItem('เริ่มเก็บออมเร็ว ได้เปรียบดอกเบี้ยทบต้น'),
                            _buildTipItem('ปรับค่าใช้จ่ายให้เหมาะสมกับไลฟ์สไตล์'),
                            _buildTipItem('พิจารณาแหล่งรายได้หลังเกษียณเพิ่มเติม'),
                            _buildTipItem('ทบทวนแผนทุกปีตามสถานการณ์'),
                          ],
                        ),
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
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullWidthSummaryItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E).withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
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

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.amber,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
