import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/investment_model.dart';
import '../../data/services/investment_service.dart';
import 'bloc/investment_calculator_cubit.dart';
import 'widgets/investment_input_section.dart';
import '../investment_calculator_details/investment_calculator_details.dart';
// import '../database_debug/database_debug_screen.dart';

class InvestmentCalculatorPage extends StatefulWidget {
  const InvestmentCalculatorPage({super.key});

  @override
  State<InvestmentCalculatorPage> createState() => _InvestmentCalculatorPageState();
}

class _InvestmentCalculatorPageState extends State<InvestmentCalculatorPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers สำหรับ Input
  final TextEditingController _initialInvestmentController = TextEditingController();
  final TextEditingController _monthlyContributionController = TextEditingController();
  final TextEditingController _annualReturnController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();

  // Variables
  InvestmentType _selectedInvestmentType = InvestmentType.balanced;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Load saved data after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedData();
    });
  }

  void _loadSavedData() {
    final state = context.read<InvestmentCalculatorCubit>().state;
    if (state is InvestmentCalculatorLoaded && !_isInitialized) {
      final calculation = state.calculation;
      _initialInvestmentController.text = calculation.initialInvestment?.toStringAsFixed(0) ?? '10000';
      _monthlyContributionController.text = calculation.monthlyContribution?.toStringAsFixed(0) ?? '2000';
      _annualReturnController.text = calculation.annualReturnRate?.toStringAsFixed(1) ?? '8.0';
      _yearsController.text = calculation.investmentYears?.toString() ?? '10';

      // Set investment type based on return rate
      if (calculation.annualReturnRate != null) {
        _selectedInvestmentType = _getInvestmentTypeFromRate(calculation.annualReturnRate!);
      }

      _isInitialized = true;
    } else if (!_isInitialized) {
      // Set default values if no saved data
      _initialInvestmentController.text = '10000';
      _monthlyContributionController.text = '2000';
      _annualReturnController.text = '8.0';
      _yearsController.text = '10';
      _updateReturnRateFromType();
      _isInitialized = true;
    }
  }

  InvestmentType _getInvestmentTypeFromRate(double rate) {
    if (rate == InvestmentType.conservative.suggestedReturnRate) return InvestmentType.conservative;
    if (rate == InvestmentType.balanced.suggestedReturnRate) return InvestmentType.balanced;
    if (rate == InvestmentType.aggressive.suggestedReturnRate) return InvestmentType.aggressive;
    return InvestmentType.custom;
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

  void _calculateInvestment() {
    final formState = _formKey.currentState;
    if (formState != null && !formState.validate()) return;

    context.read<InvestmentCalculatorCubit>().calculate(
      initialInvestment: _initialInvestmentController.text.replaceAll(',', ''),
      monthlyContribution: _monthlyContributionController.text.replaceAll(',', ''),
      annualReturnRate: _annualReturnController.text,
      investmentYears: _yearsController.text,
    );
  }

  void _navigateToDetails(InvestmentModel calculation) {
    final schedule = InvestmentService.generateInvestmentSchedule(
      initialInvestment: calculation.initialInvestment ?? 0,
      monthlyContribution: calculation.monthlyContribution ?? 0,
      annualReturnRate: calculation.annualReturnRate ?? 0,
      investmentYears: calculation.investmentYears ?? 0,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvestmentCalculatorDetailsPage(calculation: calculation, scheduleItems: schedule),
      ),
    );
  }

  void _clearData() {
    // ซ่อน keyboard ก่อน reset
    FocusScope.of(context).unfocus();

    setState(() {
      _selectedInvestmentType = InvestmentType.balanced;
    });

    _initialInvestmentController.text = '10000';
    _monthlyContributionController.text = '2000';
    _annualReturnController.text = '8.0';
    _yearsController.text = '10';

    _updateReturnRateFromType();

    context.read<InvestmentCalculatorCubit>().clear();
  }

  void _calculateAndNavigateToDetails() {
    _calculateInvestment();

    // Wait for calculation to complete then navigate
    Future.delayed(const Duration(milliseconds: 500), () {
      final state = context.read<InvestmentCalculatorCubit>().state;
      if (state is InvestmentCalculatorLoaded) {
        _navigateToDetails(state.calculation);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(context, MaterialPageRoute(builder: (context) => const DatabaseDebugScreen()));
      //   },
      //   backgroundColor: const Color(0xFF6C63FF),
      //   child: const Icon(Icons.storage, color: Colors.white),
      // ),
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
                child: BlocConsumer<InvestmentCalculatorCubit, InvestmentCalculatorState>(
                  listener: (context, state) {
                    if (state is InvestmentCalculatorError) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
                    }
                  },
                  builder: (context, state) {
                    final isCalculating = state is InvestmentCalculatorLoading;

                    return InvestmentInputSection(
                      formKey: _formKey,
                      initialInvestmentController: _initialInvestmentController,
                      monthlyContributionController: _monthlyContributionController,
                      annualReturnController: _annualReturnController,
                      yearsController: _yearsController,
                      selectedInvestmentType: _selectedInvestmentType,
                      isCalculating: isCalculating,
                      onInvestmentTypeChanged: (type) {
                        setState(() {
                          _selectedInvestmentType = type;
                          _updateReturnRateFromType();
                        });
                        _calculateInvestment();
                      },
                      onCalculate: _calculateAndNavigateToDetails,
                      onReset: _clearData,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
