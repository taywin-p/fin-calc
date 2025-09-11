import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SavingsSummaryChartWidget extends StatelessWidget {
  final double currentSavings;
  final double totalDeposits;
  final double totalInterest;
  final double finalAmount;

  const SavingsSummaryChartWidget({
    super.key,
    required this.currentSavings,
    required this.totalDeposits,
    required this.totalInterest,
    required this.finalAmount,
  });

  @override
  Widget build(BuildContext context) {
    if (finalAmount <= 0) {
      return Container();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // หัวข้อ
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              const Text(
                'สรุปเงินรวมสุดท้าย',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // แผนภูมิแท่งเดียว - จัดให้ชิดซ้าย
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ป้ายกำกับด้านซ้าย - ตัวเลข 3.1M
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatNumberShort(finalAmount),
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text('บาท', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10)),
                ],
              ),
              const SizedBox(width: 12),

              // แท่งกราฟ
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();

                      // ซ่อน keyboard และ clear focus ก่อนเปิด dialog
                      FocusScope.of(context).unfocus();

                      // เก็บ scroll position ปัจจุบัน
                      final scrollController = Scrollable.of(context);
                      final currentOffset = scrollController.position.pixels;

                      _showDetailDialog(context, currentOffset);
                    },
                    borderRadius: BorderRadius.circular(8),
                    splashColor: Colors.white.withOpacity(0.3),
                    highlightColor: Colors.white.withOpacity(0.15),
                    child: Container(
                      height: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        children: [
                          // ส่วนที่ 1: เงินออมปัจจุบัน (สีน้ำเงิน-ม่วง)
                          Expanded(
                            flex: (currentSavings * 100 / finalAmount).round(),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [const Color(0xFF667EEA), const Color(0xFF764BA2)],
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                              ),
                              child:
                                  currentSavings / finalAmount > 0.15
                                      ? Center(
                                        child: Text(
                                          _formatNumberShort(currentSavings),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )
                                      : null,
                            ),
                          ),

                          // ส่วนที่ 2: เงินฝากเพิ่ม (สีเขียวมิ้นต์)
                          Expanded(
                            flex: (totalDeposits * 100 / finalAmount).round(),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [const Color(0xFF11998E), const Color(0xFF38EF7D)],
                                ),
                              ),
                              child:
                                  totalDeposits / finalAmount > 0.25
                                      ? Center(
                                        child: Text(
                                          _formatNumberShort(totalDeposits),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )
                                      : null,
                            ),
                          ),

                          // ส่วนที่ 3: ดอกเบี้ยรวม (สีชมพูฟิวเซีย)
                          Expanded(
                            flex: (totalInterest * 100 / finalAmount).round(),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [const Color(0xFFF093FB), const Color(0xFFF5576C)],
                                ),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              child:
                                  totalInterest / finalAmount > 0.15
                                      ? Center(
                                        child: Text(
                                          _formatNumberShort(totalInterest),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )
                                      : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Legend ด้านล่าง - จัดตรงกลาง
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('เงินออมปัจจุบัน', const Color(0xFF667EEA)),
              const SizedBox(width: 16),
              _buildLegendItem('เงินฝากเพิ่ม', const Color(0xFF11998E)),
              const SizedBox(width: 16),
              _buildLegendItem('ดอกเบี้ยรวม', const Color(0xFFF093FB)),
            ],
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(BuildContext context, double scrollOffset) {
    // เก็บ scroll position ปัจจุบัน
    final scrollController = Scrollable.of(context);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('รายละเอียดเงินรวมสุดท้าย', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ],
          ),
          content: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow('เงินออมปัจจุบัน', currentSavings, const Color(0xFF667EEA)),
                      const SizedBox(height: 8),
                      _buildDetailRow('เงินฝากเพิ่ม', totalDeposits, const Color(0xFF11998E)),
                      const SizedBox(height: 8),
                      _buildDetailRow('ดอกเบี้ยรวม', totalInterest, const Color(0xFFF093FB)),
                      const Divider(height: 20, thickness: 1),
                      _buildDetailRow('รวมทั้งหมด', finalAmount, Colors.green, isTotal: true),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[700], size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'แท่งแสดงสัดส่วนการแบ่งเงินตามประเภท',
                          style: TextStyle(color: Colors.blue[700], fontSize: 12, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                // ป้องกันการ autofocus กลับไปที่ text field และกู้คืน scroll position
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // ทำให้แน่ใจว่าไม่มี focus อยู่ที่ text field ใดๆ
                  FocusScope.of(context).unfocus();
                  // กู้คืน scroll position
                  if (scrollController.position.hasContentDimensions) {
                    scrollController.position.jumpTo(scrollOffset);
                  }
                });
              },
              icon: const Icon(Icons.close),
              label: const Text('ปิด'),
              style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
            ),
          ],
        );
      },
    ).then((_) {
      // เป็นการป้องกันเพิ่มเติม หากการกู้คืนใน onPressed ไม่ทำงาน
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // clear focus อีกครั้งเพื่อป้องกัน autofocus
        FocusScope.of(context).unfocus();
        if (scrollController.position.hasContentDimensions) {
          scrollController.position.jumpTo(scrollOffset);
        }
      });
    });
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 11, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildDetailRow(String label, double amount, Color color, {bool isTotal = false}) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: isTotal ? 16 : 14, fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500),
          ),
        ),
        Text(
          _formatNumber(amount),
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            color: isTotal ? Colors.black : Colors.grey[700],
          ),
        ),
      ],
    );
  }

  String _formatNumber(double number) {
    final formatter = NumberFormat('#,##0.00');
    return '${formatter.format(number)} บาท';
  }

  String _formatNumberShort(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    }
    return number.toStringAsFixed(0);
  }
}
