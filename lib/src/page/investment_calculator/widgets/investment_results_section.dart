import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../data/models/investment_model.dart';

class InvestmentResultsSection extends StatefulWidget {
  final InvestmentModel? calculationResult;
  final List<InvestmentScheduleItem> scheduleItems;
  final bool isCalculating;
  final VoidCallback onPrevious;

  const InvestmentResultsSection({
    super.key,
    required this.calculationResult,
    required this.scheduleItems,
    required this.isCalculating,
    required this.onPrevious,
  });

  @override
  State<InvestmentResultsSection> createState() => _InvestmentResultsSectionState();
}

class _InvestmentResultsSectionState extends State<InvestmentResultsSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text('ผลการคำนวณ', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          if (widget.isCalculating)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.blue),
                    SizedBox(height: 16),
                    Text('กำลังคำนวณ...', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
              ),
            )
          else
            Expanded(child: _buildAllContentSection()),

          // Bottom navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: widget.onPrevious,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('ย้อนกลับ', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAllContentSection() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Results Summary
          _buildResultsSummary(),
          const SizedBox(height: 30),

          // Charts Section
          const Text('กราฟและตาราง', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // Line Chart
          SizedBox(height: 300, child: _buildLineChart()),
          const SizedBox(height: 30),

          // Bar Chart
          SizedBox(height: 300, child: _buildBarChart()),
          const SizedBox(height: 30),

          // Schedule Table
          SizedBox(height: 400, child: _buildScheduleTable()),
        ],
      ),
    );
  }

  Widget _buildResultsSummary() {
    if (widget.calculationResult == null) {
      return const Center(child: Text('ไม่มีข้อมูล', style: TextStyle(color: Colors.white)));
    }

    final result = widget.calculationResult!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          // Input information
          _buildSummaryRow('เงินลงทุนครั้งแรก', result.initialInvestment ?? 0, Colors.cyan),
          const SizedBox(height: 10),
          _buildSummaryRow('เงินลงทุนรายเดือน', result.monthlyContribution ?? 0, Colors.orange),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('อัตราผลตอบแทนต่อปี', style: TextStyle(color: Colors.white, fontSize: 16)),
              Text(
                '${(result.annualReturnRate ?? 0).toStringAsFixed(1)}%',
                style: const TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('ระยะเวลาการลงทุน', style: TextStyle(color: Colors.white, fontSize: 16)),
              Text(
                '${result.investmentYears ?? 0} ปี',
                style: const TextStyle(color: Colors.purple, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Divider(color: Colors.white30, thickness: 2),
          const SizedBox(height: 15),
          // Results
          _buildSummaryRow('เงินต้นรวม', result.totalContributions ?? 0, Colors.blue),
          const SizedBox(height: 10),
          _buildSummaryRow('ผลตอบแทนรวม', result.totalReturns ?? 0, Colors.green),
          const SizedBox(height: 10),
          const Divider(color: Colors.white30),
          const SizedBox(height: 10),
          _buildSummaryRow('มูลค่ารวมสุดท้าย', result.finalAmount ?? 0, Colors.white, isLarge: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, Color color, {bool isLarge = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: isLarge ? 18 : 16,
            fontWeight: isLarge ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          '฿${_formatNumber(value)}',
          style: TextStyle(color: color, fontSize: isLarge ? 20 : 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String _formatNumber(double number) {
    return number.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  Widget _buildLineChart() {
    if (widget.scheduleItems.isEmpty) {
      return const Center(child: Text('ไม่มีข้อมูล', style: TextStyle(color: Colors.white)));
    }

    // Calculate year interval for better display
    final yearInterval = _calculateYearInterval(widget.scheduleItems.length);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'กราฟแสดงการเติบโตของเงินลงทุน',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: (widget.scheduleItems.last.totalValue) / 5,
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
                        if (year >= 0 && year < widget.scheduleItems.length) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              'ปี${widget.scheduleItems[year].year}',
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
                      interval: (widget.scheduleItems.last.totalValue) / 5,
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
                        widget.scheduleItems.asMap().entries.map((entry) {
                          return FlSpot(entry.key.toDouble(), entry.value.totalValue);
                        }).toList(),
                    isCurved: true,
                    gradient: LinearGradient(colors: [Colors.blue, Colors.green]),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: Colors.blue,
                        );
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    if (widget.scheduleItems.isEmpty) {
      return const Center(child: Text('ไม่มีข้อมูล', style: TextStyle(color: Colors.white)));
    }

    if (widget.calculationResult == null) {
      return const Center(child: Text('ไม่มีข้อมูล', style: TextStyle(color: Colors.white)));
    }

    final totalContributions = widget.calculationResult!.totalContributions ?? 0;
    final totalReturns = widget.calculationResult!.totalReturns ?? 0;
    final maxValue = totalContributions + totalReturns;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'การแบ่งสัดส่วนของการลงทุน',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 20),

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

          // Legend with values
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // เงินต้นรวม
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(4)),
                      ),
                      const SizedBox(width: 8),
                      const Text('เงินต้นรวม', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '฿${_formatNumber(totalContributions)}',
                    style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              // ผลตอบแทนรวม
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(4)),
                      ),
                      const SizedBox(width: 8),
                      const Text('ผลตอบแทนรวม', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '฿${_formatNumber(totalReturns)}',
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleTable() {
    if (widget.scheduleItems.isEmpty)
      return const Center(child: Text('ไม่มีข้อมูล', style: TextStyle(color: Colors.white)));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text('ปี', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('ลงทุนรายปี', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('ผลตอบแทน', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('มูลค่ารวม', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          // Data rows
          Expanded(
            child: ListView.builder(
              itemCount: widget.scheduleItems.length,
              itemBuilder: (context, index) {
                final item = widget.scheduleItems[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1)))),
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: Text(item.year.toString(), style: const TextStyle(color: Colors.white))),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '฿${_formatNumber(item.yearlyContribution)}',
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '฿${_formatNumber(item.yearlyReturns)}',
                          style: const TextStyle(color: Colors.green),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '฿${_formatNumber(item.totalValue)}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
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

  // Helper function to calculate optimal year interval for display
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
