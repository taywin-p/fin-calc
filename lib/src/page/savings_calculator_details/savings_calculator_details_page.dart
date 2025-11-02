import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'bloc/savings_calculator_details_cubit.dart';
import 'savings_calculator_details_state.dart';

class SavingsCalculatorDetailsPage extends StatelessWidget {
  final dynamic calculation;

  const SavingsCalculatorDetailsPage({super.key, required this.calculation});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SavingsCalculatorDetailsCubit()..loadData(calculation),
      child: const SavingsCalculatorDetailsView(),
    );
  }
}

class SavingsCalculatorDetailsView extends StatelessWidget {
  const SavingsCalculatorDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final calculation = context.read<SavingsCalculatorDetailsCubit>().calculation;
    
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
                            'รายละเอียดการออม',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Text(
                            'ตารางการออมรายเดือน',
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
                      child: const Icon(Icons.table_chart_rounded, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Summary Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFF667EEA).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with toggle button
                    BlocBuilder<SavingsCalculatorDetailsCubit, SavingsCalculatorDetailsState>(
                      builder: (context, state) {
                        final cubit = context.read<SavingsCalculatorDetailsCubit>();
                        return GestureDetector(
                          onTap: () {
                            cubit.toggleSummaryVisibility();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'สรุปการออม',
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
                    
                    // Summary content (แสดง/ซ่อนตาม state)
                    BlocBuilder<SavingsCalculatorDetailsCubit, SavingsCalculatorDetailsState>(
                      builder: (context, state) {
                        final cubit = context.read<SavingsCalculatorDetailsCubit>();
                        if (!cubit.isSummaryVisible) return const SizedBox.shrink();

                        return Column(
                          children: [
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSummaryItem(
                                    'เป้าหมาย',
                                    '${NumberFormat('#,##0.00').format(calculation?.savingsGoal ?? 0)} บาท',
                                    Icons.flag_outlined,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildSummaryItem(
                                    'เวลาที่ใช้',
                                    '${(calculation?.timeToGoalMonths ?? 0).toInt()} เดือน',
                                    Icons.schedule_outlined,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSummaryItem(
                                    'เงินออมรวม',
                                    '${NumberFormat('#,##0.00').format((calculation?.monthlyDeposit ?? 0) * (calculation?.timeToGoalMonths ?? 0))} บาท',
                                    Icons.add_card_outlined,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildSummaryItem(
                                    'ดอกเบี้ยรวม',
                                    '${NumberFormat('#,##0.00').format(calculation?.totalInterest ?? 0)} บาท',
                                    Icons.trending_up_rounded,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Table
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E).withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                  ),
                  child: Column(
                    children: [
                      // Table Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)],
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'เดือน',
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'เงินออมสะสม',
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'ดอกเบี้ยสะสม',
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'ยอดรวม',
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Table Body
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: calculation?.timeToGoalMonths?.toInt() ?? 0,
                          itemBuilder: (context, index) => _buildTableRow(index + 1, calculation),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
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
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(int month, calculation) {
    final numberFormat = NumberFormat('#,##0');
    
    // คำนวณข้อมูลสำหรับแต่ละเดือน
    final monthlyDeposit = calculation?.monthlyDeposit ?? 0;
    final interestRate = (calculation?.interestRate ?? 0) / 100 / 12; // อัตราดอกเบี้ยรายเดือน
    final currentSavings = calculation?.currentSavings ?? 0;
    
    // คำนวณยอดสะสมและดอกเบี้ยสะสม
    double totalSavings = currentSavings;
    double totalInterest = 0;
    
    for (int i = 1; i <= month; i++) {
      totalSavings += monthlyDeposit;
      double monthlyInterest = totalSavings * interestRate;
      totalInterest += monthlyInterest;
      totalSavings += monthlyInterest;
    }
    
    final isEvenRow = month % 2 == 0;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isEvenRow ? Colors.white.withOpacity(0.05) : Colors.transparent,
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$month',
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              numberFormat.format(currentSavings + (monthlyDeposit * month)),
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              numberFormat.format(totalInterest),
              style: TextStyle(color: Colors.green.shade300, fontSize: 13, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              numberFormat.format(totalSavings),
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}