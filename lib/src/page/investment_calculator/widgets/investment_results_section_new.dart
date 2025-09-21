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

class _InvestmentResultsSectionState extends State<InvestmentResultsSection> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showCharts = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Line Chart, Pie Chart, Table
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with toggle button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ผลการคำนวณ',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (widget.calculationResult != null && widget.scheduleItems.isNotEmpty)
                IconButton(
                  onPressed: () {
                    setState(() {
                      _showCharts = !_showCharts;
                    });
                  },
                  icon: Icon(_showCharts ? Icons.assessment : Icons.bar_chart, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue.withOpacity(0.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
            ],
          ),
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
          else if (widget.calculationResult == null)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calculate, size: 80, color: Colors.white.withOpacity(0.3)),
                    const SizedBox(height: 16),
                    Text(
                      'กรุณากรอกข้อมูลและคำนวณก่อน',
                      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(child: _showCharts ? _buildChartsSection() : _buildResultsSection()),

          // Navigation Button
          SizedBox(
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
          ),
        ],
      ),
    );
  }

  // Build Results Section
  Widget _buildResultsSection() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Main Result Cards
          _buildMainResultCard(),
          const SizedBox(height: 16),

          // Detailed Results
          _buildDetailedResults(),
          const SizedBox(height: 16),

          // Investment Summary
          _buildInvestmentSummary(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // Build Charts Section
  Widget _buildChartsSection() {
    return Column(
      children: [
        // Tab Bar
        Container(
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(12)),
            indicatorPadding: const EdgeInsets.all(4),
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.show_chart, size: 16),
                    SizedBox(width: 4),
                    Text('การเติบโต', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.pie_chart, size: 16),
                    SizedBox(width: 4),
                    Text('สัดส่วน', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.table_chart, size: 16),
                    SizedBox(width: 4),
                    Text('ตาราง', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [_buildLineChart(), _buildPieChart(), _buildScheduleTable()],
          ),
        ),
      ],
    );
  }

  Widget _buildMainResultCard() {
    final finalAmount = widget.calculationResult!.finalAmount ?? 0;
    final totalContributions = widget.calculationResult!.totalContributions ?? 0;
    final totalReturns = widget.calculationResult!.totalReturns ?? 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: const Color(0xFF4facfe).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'มูลค่าการลงทุนสุดท้าย',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Text(
            '฿${_formatNumber(finalAmount)}',
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text('เงินลงทุนรวม', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(
                      '฿${_formatNumber(totalContributions)}',
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
              Expanded(
                child: Column(
                  children: [
                    Text('ผลตอบแทนรวม', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(
                      '฿${_formatNumber(totalReturns)}',
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedResults() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'รายละเอียดการลงทุน',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          _buildResultRow(
            'เงินลงทุนครั้งแรก',
            '฿${_formatNumber(widget.calculationResult!.initialInvestment ?? 0)}',
            Icons.account_balance_wallet,
          ),

          _buildResultRow(
            'เงินลงทุนรายเดือน',
            '฿${_formatNumber(widget.calculationResult!.monthlyContribution ?? 0)}',
            Icons.calendar_month,
          ),

          _buildResultRow(
            'อัตราผลตอบแทนต่อปี',
            '${(widget.calculationResult!.annualReturnRate ?? 0).toStringAsFixed(2)}%',
            Icons.trending_up,
          ),

          _buildResultRow('ระยะเวลาการลงทุน', '${widget.calculationResult!.investmentYears ?? 0} ปี', Icons.schedule),
        ],
      ),
    );
  }

  Widget _buildInvestmentSummary() {
    final totalContributions = widget.calculationResult!.totalContributions ?? 0;
    final totalReturns = widget.calculationResult!.totalReturns ?? 0;
    final returnPercentage = totalContributions > 0 ? (totalReturns / totalContributions) * 100 : 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'สรุปผลการลงทุน',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('เงินลงทุน vs ผลตอบแทน', style: TextStyle(color: Colors.white.withOpacity(0.8))),
                  Text(
                    '${returnPercentage.toStringAsFixed(1)}% ผลตอบแทน',
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 8,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                child: Row(
                  children: [
                    Expanded(
                      flex: totalContributions.round(),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: totalReturns.round(),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'เงินลงทุน ฿${_formatNumber(totalContributions)}',
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'ผลตอบแทน ฿${_formatNumber(totalReturns)}',
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    if (widget.scheduleItems.isEmpty)
      return const Center(child: Text('ไม่มีข้อมูล', style: TextStyle(color: Colors.white)));

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
            horizontalInterval: _calculateInterval(spots.isNotEmpty ? spots.last.y : 100000),
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) => FlLine(color: Colors.white.withOpacity(0.1), strokeWidth: 1),
            getDrawingVerticalLine: (value) => FlLine(color: Colors.white.withOpacity(0.1), strokeWidth: 1),
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
                interval: _calculateInterval(spots.isNotEmpty ? spots.last.y : 100000),
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
            LineChartBarData(
              spots: spots,
              isCurved: true,
              gradient: const LinearGradient(colors: [Color(0xFF4facfe), Color(0xFF00f2fe)]),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter:
                    (spot, percent, barData, index) => FlDotCirclePainter(
                      radius: 4,
                      color: Colors.white,
                      strokeWidth: 2,
                      strokeColor: const Color(0xFF4facfe),
                    ),
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
            LineChartBarData(
              spots: contributionSpots,
              isCurved: true,
              color: Colors.orange,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter:
                    (spot, percent, barData, index) =>
                        FlDotCirclePainter(radius: 3, color: Colors.white, strokeWidth: 2, strokeColor: Colors.orange),
              ),
              dashArray: [5, 5],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    if (widget.calculationResult == null)
      return const Center(child: Text('ไม่มีข้อมูล', style: TextStyle(color: Colors.white)));

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

  Widget _buildResultRow(String label, String value, IconData icon, {Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: textColor ?? Colors.white.withOpacity(0.7)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: TextStyle(color: textColor ?? Colors.white.withOpacity(0.8), fontSize: 14)),
          ),
          Text(value, style: TextStyle(color: textColor ?? Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
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
