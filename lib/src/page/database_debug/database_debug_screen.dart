import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../../data/models/savings_model.dart';
import '../../data/models/home_loan_model.dart';
import '../../data/models/investment_model.dart';
import '../../data/models/retirement_model.dart';
import '../../data/models/car_loan_model.dart';

class DatabaseDebugScreen extends StatefulWidget {
  const DatabaseDebugScreen({super.key});

  @override
  State<DatabaseDebugScreen> createState() => _DatabaseDebugScreenState();
}

class _DatabaseDebugScreenState extends State<DatabaseDebugScreen> {
  late Box _calculationsBox;
  Map<String, dynamic> _boxData = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _calculationsBox = Hive.box('calculations');
    _boxData = {};

    for (var key in _calculationsBox.keys) {
      _boxData[key.toString()] = _calculationsBox.get(key);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            _buildHeader(),

            // Stats Section
            _buildStatsSection(),

            // Data List
            Expanded(child: _buildDataList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Database Debug',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: _loadData),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    final boxPath = _calculationsBox.path ?? 'N/A';
    final boxSize = _getBoxSize();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF4facfe), Color(0xFF00f2fe)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Box Information',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildStatRow('Box Name', _calculationsBox.name),
          _buildStatRow('Total Keys', '${_boxData.length}'),
          _buildStatRow('Is Open', _calculationsBox.isOpen ? 'Yes' : 'No'),
          _buildStatRow('Is Empty', _calculationsBox.isEmpty ? 'Yes' : 'No'),
          _buildStatRow('Size', boxSize),
          const SizedBox(height: 8),
          Text(
            'Path: $boxPath',
            style: const TextStyle(color: Colors.white70, fontSize: 11),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDataList() {
    if (_boxData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 80, color: Colors.white.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text('No data stored', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _boxData.length,
      itemBuilder: (context, index) {
        final key = _boxData.keys.elementAt(index);
        final value = _boxData[key];

        return _buildDataCard(key, value);
      },
    );
  }

  Widget _buildDataCard(String key, dynamic value) {
    final String displayName = _getDisplayName(key);
    final String typeName = _getTypeName(value);
    final IconData icon = _getIcon(key);
    final Color color = _getColor(key);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E).withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 24),
          ),
          title: Text(
            displayName,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          subtitle: Text('Type: $typeName', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.copy, color: Colors.white70, size: 20),
                onPressed: () => _copyToClipboard(key, value),
              ),
              Icon(Icons.keyboard_arrow_down, color: Colors.white.withOpacity(0.6)),
            ],
          ),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildKeyValueRow('Key', key),
                  const Divider(color: Colors.white24, height: 24),
                  _buildDataDetails(value),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyValueRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataDetails(dynamic value) {
    if (value == null) {
      return const Text('null', style: TextStyle(color: Colors.white54));
    }

    if (value is SavingsModel) {
      return _buildSavingsDetails(value);
    } else if (value is HomeLoanModel) {
      return _buildHomeLoanDetails(value);
    } else if (value is InvestmentModel) {
      return _buildInvestmentDetails(value);
    } else if (value is RetirementModel) {
      return _buildRetirementDetails(value);
    } else if (value is CarLoanModel) {
      return _buildCarLoanDetails(value);
    }

    // Generic display
    return SelectableText(
      value.toString(),
      style: const TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'monospace'),
    );
  }

  Widget _buildSavingsDetails(SavingsModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Savings Goal', '฿${_formatNumber(model.savingsGoal)}'),
        _buildDetailRow('Current Savings', '฿${_formatNumber(model.currentSavings)}'),
        _buildDetailRow('Monthly Deposit', '฿${_formatNumber(model.monthlyDeposit)}'),
        _buildDetailRow('Interest Rate', '${model.interestRate?.toStringAsFixed(2) ?? 'N/A'}%'),
        _buildDetailRow('Time to Goal', '${model.timeToGoalMonths ?? 'N/A'} months'),
        _buildDetailRow('Final Amount', '฿${_formatNumber(model.finalAmount)}'),
        _buildDetailRow('Total Deposits', '฿${_formatNumber(model.totalDeposits)}'),
        _buildDetailRow('Total Interest', '฿${_formatNumber(model.totalInterest)}'),
        if (model.calculatedDate != null) _buildDetailRow('Calculated Date', _formatDate(model.calculatedDate!)),
        if (model.goalAchievementDate != null)
          _buildDetailRow('Achievement Date', _formatDate(model.goalAchievementDate!)),
      ],
    );
  }

  Widget _buildHomeLoanDetails(HomeLoanModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('House Price', '฿${_formatNumber(model.housePrice)}'),
        _buildDetailRow('Down Payment', '฿${_formatNumber(model.downPayment)}'),
        _buildDetailRow('Loan Amount', '฿${_formatNumber(model.loanAmount)}'),
        _buildDetailRow('Interest Rate', '${model.interestRate?.toStringAsFixed(2) ?? 'N/A'}%'),
        _buildDetailRow('Loan Term', '${model.loanTermYears ?? 'N/A'} years'),
        _buildDetailRow('Monthly Payment', '฿${_formatNumber(model.monthlyPayment)}'),
        _buildDetailRow('Total Payment', '฿${_formatNumber(model.totalPayment)}'),
        _buildDetailRow('Total Interest', '฿${_formatNumber(model.totalInterest)}'),
        if (model.calculatedDate != null) _buildDetailRow('Calculated Date', _formatDate(model.calculatedDate!)),
      ],
    );
  }

  Widget _buildInvestmentDetails(InvestmentModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Initial Investment', '฿${_formatNumber(model.initialInvestment)}'),
        _buildDetailRow('Monthly Contribution', '฿${_formatNumber(model.monthlyContribution)}'),
        _buildDetailRow('Annual Return Rate', '${model.annualReturnRate?.toStringAsFixed(2) ?? 'N/A'}%'),
        _buildDetailRow('Investment Years', '${model.investmentYears ?? 'N/A'} years'),
        _buildDetailRow('Final Amount', '฿${_formatNumber(model.finalAmount)}'),
        _buildDetailRow('Total Contributions', '฿${_formatNumber(model.totalContributions)}'),
        _buildDetailRow('Total Returns', '฿${_formatNumber(model.totalReturns)}'),
        if (model.calculatedDate != null) _buildDetailRow('Calculated Date', _formatDate(model.calculatedDate!)),
      ],
    );
  }

  Widget _buildRetirementDetails(RetirementModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Current Age', '${model.currentAge ?? 'N/A'}'),
        _buildDetailRow('Retirement Age', '${model.retirementAge ?? 'N/A'}'),
        _buildDetailRow('Current Savings', '฿${_formatNumber(model.currentSavings)}'),
        _buildDetailRow('Monthly Expenses', '฿${_formatNumber(model.monthlyExpenses)}'),
        _buildDetailRow('Life Expectancy', '${model.lifeExpectancy ?? 'N/A'}'),
        _buildDetailRow('Total Retirement Needed', '฿${_formatNumber(model.totalRetirementNeeded)}'),
        _buildDetailRow('Monthly Savings Needed', '฿${_formatNumber(model.monthlySavingsNeeded)}'),
        if (model.calculatedDate != null) _buildDetailRow('Calculated Date', _formatDate(model.calculatedDate!)),
      ],
    );
  }

  Widget _buildCarLoanDetails(CarLoanModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Car Price', '฿${_formatNumber(model.carPrice)}'),
        _buildDetailRow('Down Payment', '฿${_formatNumber(model.downPayment)}'),
        _buildDetailRow('Loan Amount', '฿${_formatNumber(model.loanAmount)}'),
        _buildDetailRow('Interest Rate', '${model.interestRate?.toStringAsFixed(2) ?? 'N/A'}%'),
        _buildDetailRow('Loan Term', '${model.loanTermYears ?? 'N/A'} years'),
        _buildDetailRow('Monthly Payment', '฿${_formatNumber(model.monthlyPayment)}'),
        _buildDetailRow('Total Payment', '฿${_formatNumber(model.totalPayment)}'),
        _buildDetailRow('Total Interest', '฿${_formatNumber(model.totalInterest)}'),
        if (model.calculatedDate != null) _buildDetailRow('Calculated Date', _formatDate(model.calculatedDate!)),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text('$label:', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  String _getDisplayName(String key) {
    switch (key) {
      case 'savings_data':
        return 'Savings Calculator';
      case 'home_loan_data':
        return 'Home Loan Calculator';
      case 'car_loan_data':
        return 'Car Loan Calculator';
      case 'investment_data':
        return 'Investment Calculator';
      case 'retirement_data':
        return 'Retirement Calculator';
      default:
        return key;
    }
  }

  String _getTypeName(dynamic value) {
    if (value == null) return 'null';
    if (value is SavingsModel) return 'SavingsModel';
    if (value is HomeLoanModel) return 'HomeLoanModel';
    if (value is InvestmentModel) return 'InvestmentModel';
    if (value is RetirementModel) return 'RetirementModel';
    if (value is CarLoanModel) return 'CarLoanModel';
    return value.runtimeType.toString();
  }

  IconData _getIcon(String key) {
    switch (key) {
      case 'savings_data':
        return Icons.savings_outlined;
      case 'home_loan_data':
        return Icons.home_outlined;
      case 'car_loan_data':
        return Icons.directions_car_outlined;
      case 'investment_data':
        return Icons.trending_up_outlined;
      case 'retirement_data':
        return Icons.beach_access_outlined;
      default:
        return Icons.data_object;
    }
  }

  Color _getColor(String key) {
    switch (key) {
      case 'savings_data':
        return const Color(0xFFa8edea);
      case 'home_loan_data':
        return const Color(0xFF667eea);
      case 'car_loan_data':
        return const Color(0xFF4A90E2);
      case 'investment_data':
        return const Color(0xFF4facfe);
      case 'retirement_data':
        return const Color(0xFFFF6B6B);
      default:
        return Colors.grey;
    }
  }

  String _getBoxSize() {
    try {
      if (_calculationsBox.path != null) {
        final file = File(_calculationsBox.path!);
        if (file.existsSync()) {
          final bytes = file.lengthSync();
          if (bytes < 1024) {
            return '$bytes B';
          } else if (bytes < 1024 * 1024) {
            return '${(bytes / 1024).toStringAsFixed(2)} KB';
          } else {
            return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
          }
        }
      }
    } catch (e) {
      return 'N/A';
    }
    return 'N/A';
  }

  String _formatNumber(double? number) {
    if (number == null) return 'N/A';
    return number.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _copyToClipboard(String key, dynamic value) {
    try {
      String jsonString;

      if (value is SavingsModel) {
        jsonString = JsonEncoder.withIndent('  ').convert({
          'key': key,
          'type': 'SavingsModel',
          'data': {
            'savingsGoal': value.savingsGoal,
            'currentSavings': value.currentSavings,
            'monthlyDeposit': value.monthlyDeposit,
            'interestRate': value.interestRate,
            'timeToGoalMonths': value.timeToGoalMonths,
            'finalAmount': value.finalAmount,
            'totalDeposits': value.totalDeposits,
            'totalInterest': value.totalInterest,
            'calculatedDate': value.calculatedDate?.toIso8601String(),
            'goalAchievementDate': value.goalAchievementDate?.toIso8601String(),
          },
        });
      } else {
        jsonString = JsonEncoder.withIndent(
          '  ',
        ).convert({'key': key, 'type': _getTypeName(value), 'value': value.toString()});
      }

      Clipboard.setData(ClipboardData(text: jsonString));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Copied $key to clipboard!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to copy: $e'), backgroundColor: Colors.red));
    }
  }
}
