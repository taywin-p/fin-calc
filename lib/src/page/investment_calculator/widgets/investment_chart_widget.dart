import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../data/models/investment_model.dart';

class InvestmentChartWidget extends StatefulWidget {
  final List<InvestmentScheduleItem> scheduleItems;
  final InvestmentModel? calculationResult;
  final VoidCallback onPrevious;

  const InvestmentChartWidget({
    super.key,
    required this.scheduleItems,
    required this.calculationResult,
    required this.onPrevious,
  });

  @override
  State<InvestmentChartWidget> createState() => _InvestmentChartWidgetState();
}

class _InvestmentChartWidgetState extends State<InvestmentChartWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showTable = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.scheduleItems.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bar_chart, size: 80, color: Colors.white.withOpacity(0.3)),
                    const SizedBox(height: 16),
                    Text(
                      'ไม่มีข้อมูลสำหรับสร้างกราฟ',
                      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            _buildNavigationButton(),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'กราฟและตารางการลงทุน',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _showTable = !_showTable;
                  });
                },
                icon: Icon(_showTable ? Icons.bar_chart : Icons.table_chart, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Tab Bar
          Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(12)),
              indicatorPadding: const EdgeInsets.all(4),
              dividerColor: Colors.transparent,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.show_chart, size: 18),
                      const SizedBox(width: 8),
                      const Text('การเติบโต', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.pie_chart, size: 18),
                      const SizedBox(width: 8),
                      const Text('สัดส่วน', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Content
          Expanded(
            child:
                _showTable
                    ? _buildScheduleTable()
                    : TabBarView(controller: _tabController, children: [_buildLineChart(), _buildPieChart()]),
          ),

          const SizedBox(height: 20),
          _buildNavigationButton(),
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    if (widget.scheduleItems.isEmpty) return const SizedBox();

    final spots = widget.scheduleItems.map((item) => FlSpot(item.year.toDouble(), item.totalValue)).toList();

    final contributionSpots =
        widget.scheduleItems.map((item) => FlSpot(item.year.toDouble(), item.totalContributed)).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: _calculateInterval(spots.last.y),
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(color: Colors.white.withOpacity(0.1), strokeWidth: 1);
            },
            getDrawingVerticalLine: (value) {
              return FlLine(color: Colors.white.withOpacity(0.1), strokeWidth: 1);
            },
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      'ปี ${value.toInt()}',
                      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 80,
                interval: _calculateInterval(spots.last.y),
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      _formatCompactNumber(value),
                      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10),
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: true, border: Border.all(color: Colors.white.withOpacity(0.2))),
          lineBarsData: [
            // Total Value Line
            LineChartBarData(
              spots: spots,
              isCurved: true,
              gradient: const LinearGradient(colors: [Color(0xFF4facfe), Color(0xFF00f2fe)]),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.white,
                    strokeWidth: 2,
                    strokeColor: const Color(0xFF4facfe),
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [const Color(0xFF4facfe).withOpacity(0.3), const Color(0xFF00f2fe).withOpacity(0.1)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Contributions Line
            LineChartBarData(
              spots: contributionSpots,
              isCurved: true,
              color: Colors.orange,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(radius: 3, color: Colors.white, strokeWidth: 2, strokeColor: Colors.orange);
                },
              ),
              dashArray: [5, 5],
            ),
          ],
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => const Color(0xFF1A1A2E),
              tooltipBorder: BorderSide(color: Colors.white.withOpacity(0.2)),
              tooltipRoundedRadius: 8,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final isTotal = spot.barIndex == 0;
                  return LineTooltipItem(
                    '${isTotal ? 'มูลค่ารวม' : 'เงินลงทุนรวม'}\n฿${_formatNumber(spot.y)}',
                    TextStyle(color: isTotal ? const Color(0xFF4facfe) : Colors.orange, fontWeight: FontWeight.bold),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    if (widget.calculationResult == null) return const SizedBox();

    final totalContributions = widget.calculationResult!.totalContributions ?? 0;
    final totalReturns = widget.calculationResult!.totalReturns ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 60,
                sections: [
                  PieChartSectionData(
                    value: totalContributions,
                    color: Colors.blue,
                    title: '${(totalContributions / (totalContributions + totalReturns) * 100).toStringAsFixed(1)}%',
                    radius: 80,
                    titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  PieChartSectionData(
                    value: totalReturns,
                    color: Colors.green,
                    title: '${(totalReturns / (totalContributions + totalReturns) * 100).toStringAsFixed(1)}%',
                    radius: 80,
                    titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    // Handle touch events if needed
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem('เงินลงทุน', Colors.blue, totalContributions),
              _buildLegendItem('ผลตอบแทน', Colors.green, totalReturns),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, double value) {
    return Column(
      children: [
        Row(
          children: [
            Container(width: 16, height: 16, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '฿${_formatNumber(value)}',
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildScheduleTable() {
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

  Widget _buildNavigationButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.onPrevious,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.withOpacity(0.3),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_back, size: 18),
            SizedBox(width: 8),
            Text('ย้อนกลับ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  double _calculateInterval(double maxValue) {
    if (maxValue <= 100000) return 20000;
    if (maxValue <= 500000) return 100000;
    if (maxValue <= 1000000) return 200000;
    if (maxValue <= 5000000) return 1000000;
    return maxValue / 5;
  }

  String _formatCompactNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    }
    return number.toStringAsFixed(0);
  }

  String _formatNumber(double number) {
    return number.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}
