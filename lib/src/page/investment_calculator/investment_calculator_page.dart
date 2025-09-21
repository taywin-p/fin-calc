import 'package:flutter/material.dart';
import '../../data/models/investment_model.dart';
import '../../data/services/investment_service.dart';
import 'widgets/investment_input_section.dart';
import '../investment_calculator_details/investment_calculator_details.dart';

class InvestmentCalculatorPage extends StatefulWidget {
  const InvestmentCalculatorPage({super.key});

  @override
  State<InvestmentCalculatorPage> createState() => _InvestmentCalculatorPageState();
}

class _InvestmentCalculatorPageState extends State<InvestmentCalculatorPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers สำหรับ Input
  final TextEditingController _initialInvestmentController = TextEditingController(text: '10000');
  final TextEditingController _monthlyContributionController = TextEditingController(text: '2000');
  final TextEditingController _annualReturnController = TextEditingController(text: '8.0');
  final TextEditingController _yearsController = TextEditingController(text: '10');

  // Variables
  InvestmentType _selectedInvestmentType = InvestmentType.balanced;
  InvestmentModel? _calculationResult;
  List<InvestmentScheduleItem> _scheduleItems = [];
  bool _isCalculating = false;

  @override
  void initState() {
    super.initState();
    _updateReturnRateFromType();
    _calculateInvestment();
  }

  @override
  void dispose() {
    _initialInvestmentController.dispose();
    _monthlyContributionController.dispose();
    _annualReturnController.dispose();
    _yearsController.dispose();
    super.dispose();
  }

  void _updateReturnRateFromType() {
    if (_selectedInvestmentType != InvestmentType.custom) {
      _annualReturnController.text = _selectedInvestmentType.suggestedReturnRate.toString();
    }
  }

  Future<void> _calculateInvestment() async {
    final formState = _formKey.currentState;
    if (formState != null && !formState.validate()) return;

    setState(() {
      _isCalculating = true;
    });

    // จำลองการคำนวณที่ใช้เวลา (เพื่อแสดง loading)
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final result = InvestmentService.calculateInvestment(
        initialInvestment: double.tryParse(_initialInvestmentController.text.replaceAll(',', '')) ?? 0,
        monthlyContribution: double.tryParse(_monthlyContributionController.text.replaceAll(',', '')) ?? 0,
        annualReturnRate: double.tryParse(_annualReturnController.text) ?? 0,
        investmentYears: int.tryParse(_yearsController.text) ?? 0,
      );

      final schedule = InvestmentService.generateInvestmentSchedule(
        initialInvestment: double.tryParse(_initialInvestmentController.text.replaceAll(',', '')) ?? 0,
        monthlyContribution: double.tryParse(_monthlyContributionController.text.replaceAll(',', '')) ?? 0,
        annualReturnRate: double.tryParse(_annualReturnController.text) ?? 0,
        investmentYears: int.tryParse(_yearsController.text) ?? 0,
      );

      setState(() {
        _calculationResult = result;
        _scheduleItems = schedule;
        _isCalculating = false;
      });
    } catch (e) {
      setState(() {
        _isCalculating = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาดในการคำนวณ: $e'), backgroundColor: Colors.red));
      }
    }
  }

  void _navigateToDetails() {
    if (_calculationResult != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  InvestmentCalculatorDetailsPage(calculation: _calculationResult!, scheduleItems: _scheduleItems),
        ),
      );
    }
  }

  void _clearData() {
    // ซ่อน keyboard ก่อน reset
    FocusScope.of(context).unfocus();

    setState(() {
      _selectedInvestmentType = InvestmentType.balanced;
      _calculationResult = null;
      _scheduleItems = [];
      _isCalculating = false;
    });

    _initialInvestmentController.text = '10000';
    _monthlyContributionController.text = '2000';
    _annualReturnController.text = '8.0';
    _yearsController.text = '10';

    _updateReturnRateFromType();
    _calculateInvestment();
  }

  void _calculateAndNavigateToDetails() async {
    await _calculateInvestment();
    if (_calculationResult != null) {
      _navigateToDetails();
    }
  }

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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'การลงทุน',
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
                      child: const Icon(Icons.trending_up_rounded, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Content - Only Input Form
              Expanded(
                child: InvestmentInputSection(
                  formKey: _formKey,
                  initialInvestmentController: _initialInvestmentController,
                  monthlyContributionController: _monthlyContributionController,
                  annualReturnController: _annualReturnController,
                  yearsController: _yearsController,
                  selectedInvestmentType: _selectedInvestmentType,
                  isCalculating: _isCalculating,
                  onInvestmentTypeChanged: (type) {
                    setState(() {
                      _selectedInvestmentType = type;
                      _updateReturnRateFromType();
                    });
                    _calculateInvestment();
                  },
                  onCalculate: _calculateAndNavigateToDetails,
                  onReset: _clearData,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
