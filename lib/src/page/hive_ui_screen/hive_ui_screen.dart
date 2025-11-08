import 'package:flutter/material.dart';
import 'package:hive_ui/hive_ui.dart';
import 'package:hive/hive.dart';

/// 🛠️ Dev Tool: Hive UI Screen
/// แสดง Raw Data และสามารถแก้ไขข้อมูลได้
/// ⚠️ ใช้เฉพาะ Debug Mode เท่านั้น!
class HiveUIScreen extends StatelessWidget {
  const HiveUIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get all opened boxes
    final calculationsBox = Hive.box('calculations');

    return Scaffold(
      appBar: AppBar(title: const Text('🛠️ Hive UI (Dev Tool)'), backgroundColor: const Color(0xFFFF6B6B)),
      body: HiveBoxesView(
        hiveBoxes: {
          calculationsBox: (json) => json, // Raw JSON converter
        },
        onError: (String errorMessage) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $errorMessage'), backgroundColor: Colors.red));
        },
      ),
    );
  }
}
