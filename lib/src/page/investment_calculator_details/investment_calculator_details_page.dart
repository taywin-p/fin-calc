import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/models/investment_model.dart';
import 'bloc/investment_calculator_details_cubit.dart';
import 'investment_calculator_details_state.dart';

class InvestmentCalculatorDetailsPage extends StatelessWidget {
  final InvestmentModel calculation;
  final List<InvestmentScheduleItem> scheduleItems;

  const InvestmentCalculatorDetailsPage({super.key, required this.calculation, required this.scheduleItems});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InvestmentCalculatorDetailsCubit(),
      child: _InvestmentCalculatorDetailsView(calculation: calculation, scheduleItems: scheduleItems),
    );
  }
}

class _InvestmentCalculatorDetailsView extends StatelessWidget {
  final InvestmentModel calculation;
  final List<InvestmentScheduleItem> scheduleItems;

  const _InvestmentCalculatorDetailsView({required this.calculation, required this.scheduleItems});

  @override
  Widget build(BuildContext context) {
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
              // Custom Header
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
                        'รายละเอียดการลงทุน',
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
                      child: const Icon(Icons.trending_up, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Summary Section
                      _buildSummarySection(context),
                      const SizedBox(height: 20),

                      // Charts Section
                      // _buildChartsSection(context),
                      // const SizedBox(height: 20),

                      // Schedule Table Section
                      _buildScheduleTableSection(context),
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

  Widget _buildSummarySection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: const Color(0xFF4facfe).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with toggle button
          BlocBuilder<InvestmentCalculatorDetailsCubit, InvestmentCalculatorDetailsState>(
            builder: (context, state) {
              final cubit = context.read<InvestmentCalculatorDetailsCubit>();
              return GestureDetector(
                onTap: () {
                  cubit.toggleSummaryVisibility();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'สรุปการลงทุน',
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
                        cubit.isSummaryVisible ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Summary Content
          BlocBuilder<InvestmentCalculatorDetailsCubit, InvestmentCalculatorDetailsState>(
            builder: (context, state) {
              final cubit = context.read<InvestmentCalculatorDetailsCubit>();
              if (!cubit.isSummaryVisible) return const SizedBox.shrink();

              return Column(
                children: [
                  const SizedBox(height: 16),
                  _buildSummaryRow('เงินลงทุนครั้งแรก', '${_formatNumber(calculation.initialInvestment ?? 0)} บาท'),
                  _buildSummaryRow('เงินลงทุนรายเดือน', '${_formatNumber(calculation.monthlyContribution ?? 0)} บาท'),
                  _buildSummaryRow('อัตราผลตอบแทนต่อปี', '${(calculation.annualReturnRate ?? 0).toStringAsFixed(1)}%'),
                  _buildSummaryRow('ระยะเวลาการลงทุน', '${calculation.investmentYears ?? 0} ปี'),
                  const Divider(color: Colors.white54, height: 24),
                  _buildSummaryRow('เงินต้นรวม', '${_formatNumber(calculation.totalContributions ?? 0)} บาท'),
                  _buildSummaryRow('ผลตอบแทนรวม', '${_formatNumber(calculation.totalReturns ?? 0)} บาท'),
                  const Divider(color: Colors.white54, height: 24),
                  _buildSummaryRow(
                    'มูลค่ารวมสุดท้าย',
                    '${_formatNumber(calculation.finalAmount ?? 0)} บาท',
                    isHighlight: true,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Charts Header with toggle
          BlocBuilder<InvestmentCalculatorDetailsCubit, InvestmentCalculatorDetailsState>(
            builder: (context, state) {
              final cubit = context.read<InvestmentCalculatorDetailsCubit>();
              return GestureDetector(
                onTap: () {
                  cubit.toggleChartsVisibility();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'กราฟการลงทุน',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        cubit.isChartsVisible ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Charts Content
          BlocBuilder<InvestmentCalculatorDetailsCubit, InvestmentCalculatorDetailsState>(
            builder: (context, state) {
              final cubit = context.read<InvestmentCalculatorDetailsCubit>();
              if (!cubit.isChartsVisible) return const SizedBox.shrink();

              return Column(
                children: [
                  const SizedBox(height: 20),

                  // Line Chart
                  const Text(
                    'กราฟแสดงการเติบโตของเงินลงทุน',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(height: 300, child: _buildLineChart()),
                  const SizedBox(height: 30),

                  // Bar Chart
                  const Text(
                    'การแบ่งสัดส่วนของการลงทุน',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(height: 200, child: _buildBarChart()),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleTableSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E).withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: const Row(
              children: [
                Expanded(flex: 1, child: _TableHeader('ปี')),
                Expanded(flex: 2, child: _TableHeader('ลงทุนรายปี')),
                Expanded(flex: 2, child: _TableHeader('ผลตอบแทน')),
                Expanded(flex: 2, child: _TableHeader('มูลค่ารวม')),
              ],
            ),
          ),

          // Table Content
          Container(
            height: 400,
            child: ListView.builder(
              itemCount: scheduleItems.length,
              itemBuilder: (context, index) {
                final item = scheduleItems[index];
                final isEven = index % 2 == 0;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isEven ? Colors.white.withOpacity(0.05) : Colors.transparent,
                    border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
                  ),
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: _TableCell(item.year.toString())),
                      Expanded(flex: 2, child: _TableCell(_formatNumber(item.yearlyContribution))),
                      Expanded(flex: 2, child: _TableCell(_formatNumber(item.yearlyReturns))),
                      Expanded(flex: 2, child: _TableCell(_formatNumber(item.totalValue))),
                    ],
                  ),
                );
              },
            ),
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
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: isHighlight ? 15 : 14,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
              shadows: const [Shadow(offset: Offset(0, 1), blurRadius: 3, color: Colors.black38)],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: isHighlight ? 15 : 14,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
              shadows: const [Shadow(offset: Offset(0, 1), blurRadius: 3, color: Colors.black38)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    if (scheduleItems.isEmpty) {
      return const Center(child: Text('ไม่มีข้อมูล', style: TextStyle(color: Colors.white)));
    }

    final yearInterval = _calculateYearInterval(scheduleItems.length);

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: (scheduleItems.last.totalValue) / 5,
          verticalInterval: yearInterval.toDouble(),
          getDrawingHorizontalLine: (value) => FlLine(color: Colors.white.withOpacity(0.1), strokeWidth: 1),
          getDrawingVerticalLine: (value) => FlLine(color: Colors.white.withOpacity(0.1), strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: yearInterval.toDouble(),
              getTitlesWidget: (double value, TitleMeta meta) {
                int year = value.toInt();
                if (year >= 0 && year < scheduleItems.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      'ปี${scheduleItems[year].year}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (scheduleItems.last.totalValue) / 5,
              reservedSize: 80,
              getTitlesWidget: (double value, TitleMeta meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    '฿${_formatCompactNumber(value)}',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: true, border: Border.all(color: Colors.white.withOpacity(0.2))),
        lineBarsData: [
          LineChartBarData(
            spots:
                scheduleItems.asMap().entries.map((entry) {
                  return FlSpot(entry.key.toDouble(), entry.value.totalValue);
                }).toList(),
            isCurved: true,
            gradient: const LinearGradient(colors: [Colors.blue, Colors.green]),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(radius: 4, color: Colors.white, strokeWidth: 2, strokeColor: Colors.blue);
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [Colors.blue.withOpacity(0.3), Colors.green.withOpacity(0.1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    final totalContributions = calculation.totalContributions ?? 0;
    final totalReturns = calculation.totalReturns ?? 0;
    final maxValue = totalContributions + totalReturns;

    return Column(
      children: [
        // Horizontal Bar Chart
        Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                // Blue section (Contributions)
                Expanded(
                  flex: (totalContributions / maxValue * 100).round(),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue, Color(0xFF1976D2)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'เงินต้น\n${(totalContributions / maxValue * 100).toStringAsFixed(1)}%',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                // Green section (Returns)
                Expanded(
                  flex: (totalReturns / maxValue * 100).round(),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green, Color(0xFF388E3C)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'ผลตอบแทน\n${(totalReturns / maxValue * 100).toStringAsFixed(1)}%',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildLegendItem('เงินต้นรวม', Colors.blue, totalContributions),
            _buildLegendItem('ผลตอบแทนรวม', Colors.green, totalReturns),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, double value) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
            ),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
        const SizedBox(height: 4),
        Text('฿${_formatNumber(value)}', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }

  String _formatNumber(double number) {
    return number.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  int _calculateYearInterval(int dataLength) {
    if (dataLength <= 5) return 1;
    if (dataLength <= 10) return 2;
    if (dataLength <= 20) return 5;
    return 10;
  }

  String _formatCompactNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    }
    return number.toStringAsFixed(0);
  }
}

class _TableHeader extends StatelessWidget {
  final String text;

  const _TableHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;

  const _TableCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(color: Colors.white, fontSize: 11), textAlign: TextAlign.center);
  }
}
