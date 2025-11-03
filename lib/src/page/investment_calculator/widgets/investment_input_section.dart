import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/models/investment_model.dart';

class InvestmentInputSection extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController initialInvestmentController;
  final TextEditingController monthlyContributionController;
  final TextEditingController annualReturnController;
  final TextEditingController yearsController;
  final InvestmentType selectedInvestmentType;
  final bool isCalculating;
  final Function(InvestmentType) onInvestmentTypeChanged;
  final VoidCallback onCalculate;
  final VoidCallback onReset;

  const InvestmentInputSection({
    super.key,
    required this.formKey,
    required this.initialInvestmentController,
    required this.monthlyContributionController,
    required this.annualReturnController,
    required this.yearsController,
    required this.selectedInvestmentType,
    required this.isCalculating,
    required this.onInvestmentTypeChanged,
    required this.onCalculate,
    required this.onReset,
  });

  @override
  State<InvestmentInputSection> createState() => _InvestmentInputSectionState();
}

class _InvestmentInputSectionState extends State<InvestmentInputSection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [_buildInputSection(), const SizedBox(height: 24), _buildActionButtons(), const SizedBox(height: 20)],
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E).withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Investment Type Selector
            _buildSectionTitle('ประเภทการลงทุน'),
            _buildInvestmentTypeSelector(),
            const SizedBox(height: 20),

            // Initial Investment
            _buildSectionTitle('เงินลงทุนครั้งแรก (บาท)'),
            _buildInputField(
              controller: widget.initialInvestmentController,
              hint: 'ระบุจำนวนเงินลงทุนครั้งแรก',
              icon: Icons.account_balance_wallet,
              validator: (value) {
                if (value == null || value.isEmpty) return null;
                final amount = double.tryParse(value.replaceAll(',', ''));
                if (amount == null) return 'กรุณาใส่ตัวเลขที่ถูกต้อง';
                if (amount < 0) return 'จำนวนเงินต้องมากกว่าหรือเท่ากับ 0';
                return null;
              },
              onChanged: (value) => _formatCurrency(widget.initialInvestmentController),
            ),
            const SizedBox(height: 16),

            // Monthly Contribution
            _buildSectionTitle('เงินลงทุนรายเดือน (บาท)'),
            _buildInputField(
              controller: widget.monthlyContributionController,
              hint: 'ระบุจำนวนเงินลงทุนรายเดือน',
              icon: Icons.calendar_month,
              validator: (value) {
                if (value == null || value.isEmpty) return null;
                final amount = double.tryParse(value.replaceAll(',', ''));
                if (amount == null) return 'กรุณาใส่ตัวเลขที่ถูกต้อง';
                if (amount < 0) return 'จำนวนเงินต้องมากกว่าหรือเท่ากับ 0';
                return null;
              },
              onChanged: (value) => _formatCurrency(widget.monthlyContributionController),
            ),
            const SizedBox(height: 16),

            // Annual Return Rate
            _buildSectionTitle('อัตราผลตอบแทนต่อปี (%)'),
            _buildInputField(
              controller: widget.annualReturnController,
              hint: 'ระบุอัตราผลตอบแทนต่อปี',
              icon: Icons.trending_up,
              suffix: '%',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณาใส่อัตราผลตอบแทน';
                }
                final rate = double.tryParse(value);
                if (rate == null) return 'กรุณาใส่ตัวเลขที่ถูกต้อง';
                if (rate < 0) return 'อัตราผลตอบแทนต้องมากกว่าหรือเท่ากับ 0';
                if (rate > 100) return 'อัตราผลตอบแทนต้องไม่เกิน 100%';
                return null;
              },
              enabled: widget.selectedInvestmentType == InvestmentType.custom,
            ),
            const SizedBox(height: 16),

            // Investment Years
            _buildSectionTitle('ระยะเวลาการลงทุน (ปี)'),
            _buildInputField(
              controller: widget.yearsController,
              hint: 'ระบุระยะเวลาการลงทุน',
              icon: Icons.schedule,
              suffix: 'ปี',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณาใส่ระยะเวลาการลงทุน';
                }
                final years = int.tryParse(value);
                if (years == null) return 'กรุณาใส่ตัวเลขที่ถูกต้อง';
                if (years <= 0) return 'ระยะเวลาต้องมากกว่า 0 ปี';
                if (years > 100) return 'ระยะเวลาต้องไม่เกิน 100 ปี';
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 4),
              child: TextButton.icon(
                onPressed: widget.isCalculating ? null : widget.onReset,
                icon: const Icon(Icons.refresh_rounded, color: Colors.white70, size: 18),
                label: const Text(
                  'รีเซ็ต',
                  style: TextStyle(color: Colors.white70, fontSize: 15, fontWeight: FontWeight.w500),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF4facfe).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: widget.isCalculating ? null : widget.onCalculate,
                icon:
                    widget.isCalculating
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                        : const Icon(Icons.calculate_rounded, color: Colors.white, size: 18),
                label: const Text(
                  'คำนวณผลลัพธ์',
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? suffix,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    bool enabled = true,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      inputFormatters: inputFormatters,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.8)),
        suffixText: suffix,
        suffixStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
        filled: true,
        fillColor: enabled ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }

  Widget _buildInvestmentTypeSelector() {
    final investmentGroups = [
      {
        'title': 'เสี่ยงต่ำ',
        'subtitle': '(2-5% ต่อปี)',
        'color': const Color(0xFF4CAF50),
        'types': [InvestmentType.conservative, InvestmentType.bond],
      },
      {
        'title': 'เสี่ยงกลาง',
        'subtitle': '(5-8% ต่อปี)',
        'color': const Color(0xFF2196F3),
        'types': [InvestmentType.balanced, InvestmentType.mutualFund, InvestmentType.etf],
      },
      {
        'title': 'เสี่ยงสูง',
        'subtitle': '(8-15% ต่อปี)',
        'color': const Color(0xFFFF9800),
        'types': [InvestmentType.aggressive, InvestmentType.stock, InvestmentType.crypto],
      },
      {
        'title': 'กำหนดเอง',
        'subtitle': '(กำหนดอัตราเองได้)',
        'color': const Color(0xFF9C27B0),
        'types': [InvestmentType.custom],
      },
    ];

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children:
            investmentGroups.map((group) {
              final groupTypes = group['types'] as List<InvestmentType>;
              final isAnySelected = groupTypes.contains(widget.selectedInvestmentType);
              final selectedType = isAnySelected ? widget.selectedInvestmentType : groupTypes.first;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => widget.onInvestmentTypeChanged(selectedType),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color:
                          isAnySelected ? (group['color'] as Color).withOpacity(0.15) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            isAnySelected ? (group['color'] as Color).withOpacity(0.5) : Colors.white.withOpacity(0.15),
                        width: isAnySelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isAnySelected ? (group['color'] as Color) : Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                            color: isAnySelected ? (group['color'] as Color) : Colors.transparent,
                          ),
                          child: isAnySelected
                              ? Icon(
                                  Icons.check,
                                  size: 12,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                group['title'] as String,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: isAnySelected ? FontWeight.w600 : FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                group['subtitle'] as String,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  void _formatCurrency(TextEditingController controller) {
    final text = controller.text.replaceAll(',', '');
    if (text.isNotEmpty) {
      final number = double.tryParse(text);
      if (number != null) {
        final formatted = number
            .toStringAsFixed(0)
            .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
        controller.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
    }
  }
}
