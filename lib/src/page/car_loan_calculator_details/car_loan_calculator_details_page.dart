import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'bloc/car_loan_calculator_details_cubit.dart';
import 'package:fin_calc/src/data/services/car_loan_calculator_service.dart';

class CarLoanCalculatorDetailsPage extends StatelessWidget {
  final dynamic calculation;

  const CarLoanCalculatorDetailsPage({super.key, required this.calculation});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CarLoanCalculatorDetailsCubit()..loadData(calculation),
      child: const CarLoanCalculatorDetailsView(),
    );
  }
}

class CarLoanCalculatorDetailsView extends StatelessWidget {
  const CarLoanCalculatorDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final calculation = context.read<CarLoanCalculatorDetailsCubit>().calculation;
    final schedule = CarLoanCalculatorService.generatePaymentSchedule(
      loanAmount: calculation?.loanAmount ?? 0,
      monthlyPayment: calculation?.monthlyPayment ?? 0,
      interestRate: calculation?.interestRate ?? 0,
      numberOfPayments: (calculation?.loanTermYears ?? 0) * 12,
    );

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
              _buildAppBar(context),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildSummaryCard(context, calculation),
                      const SizedBox(height: 16),
                      _buildScheduleTable(schedule),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('รายละเอียดสินเชื่อรถยนต์', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 0.3)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.table_chart_rounded, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, calculation) {
    final numberFormat = NumberFormat('#,##0.00');
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF4A90E2), Color(0xFF357ABD)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: const Color(0xFF4A90E2).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with toggle button
          BlocBuilder<CarLoanCalculatorDetailsCubit, CarLoanCalculatorDetailsState>(
            builder: (context, state) {
              final cubit = context.read<CarLoanCalculatorDetailsCubit>();
              return InkWell(
                onTap: () {
                  cubit.toggleSummaryVisibility();
                },
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'สรุปสินเชื่อรถยนต์',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
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
                ),
              );
            },
          ),

          // เนื้อหาส่วนสรุป (แสดง/ซ่อนตาม state)
          BlocBuilder<CarLoanCalculatorDetailsCubit, CarLoanCalculatorDetailsState>(
            builder: (context, state) {
              final cubit = context.read<CarLoanCalculatorDetailsCubit>();
              if (!cubit.isSummaryVisible) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: [
                    _buildSummaryRow('ราคารถ', '${numberFormat.format(calculation?.carPrice ?? 0)} บาท'),
                    _buildSummaryRow('เงินดาวน์', '${numberFormat.format(calculation?.downPayment ?? 0)} บาท'),
                    _buildSummaryRow('จำนวนเงินกู้', '${numberFormat.format(calculation?.loanAmount ?? 0)} บาท'),
                    _buildSummaryRow('อัตราดอกเบี้ยต่อปี', '${calculation?.interestRate?.toStringAsFixed(2) ?? '0.00'}%'),
                    _buildSummaryRow('ระยะเวลาผ่อน', '${calculation?.loanTermYears ?? 0} ปี'),
                    const Divider(color: Colors.white54, height: 20),
                    _buildSummaryRow('ค่างวดต่อเดือน', '${numberFormat.format(calculation?.monthlyPayment ?? 0)} บาท', isHighlight: true),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(color: Colors.white, fontSize: isHighlight ? 16 : 14, fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildScheduleTable(List schedule) {
    final numberFormat = NumberFormat('#,##0.00');
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E).withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)],
              ),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Row(
              children: [
                const Expanded(flex: 1, child: Text('งวด', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
                const Expanded(flex: 2, child: Text('เงินต้น', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.right)),
                const Expanded(flex: 2, child: Text('ดอกเบี้ย', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.right)),
                const Expanded(flex: 2, child: Text('คงเหลือ', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.right)),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: schedule.length,
            itemBuilder: (context, index) {
              final item = schedule[index];
              final isEven = index % 2 == 0;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isEven ? Colors.white.withOpacity(0.05) : Colors.transparent,
                  border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1), width: 1)),
                ),
                child: Row(
                  children: [
                    Expanded(flex: 1, child: Text('${item.month}', style: const TextStyle(color: Colors.white, fontSize: 13), textAlign: TextAlign.center)),
                    Expanded(flex: 2, child: Text(numberFormat.format(item.principal), style: const TextStyle(color: Colors.white, fontSize: 13), textAlign: TextAlign.right)),
                    Expanded(flex: 2, child: Text(numberFormat.format(item.interest), style: const TextStyle(color: Colors.white, fontSize: 13), textAlign: TextAlign.right)),
                    Expanded(flex: 2, child: Text(numberFormat.format(item.remainingBalance), style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500), textAlign: TextAlign.right)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
