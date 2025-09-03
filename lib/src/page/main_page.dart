import 'package:flutter/material.dart';
import 'package:fin_calc/src/page/home_loan_calculator/home_loan_calculator.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

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
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF9D50BB)]),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6C63FF).withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Financial Calculator \nBy เทวิน สุดหล่อ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  shadows: [Shadow(offset: Offset(0, 2), blurRadius: 4, color: Colors.black45)],
                                ),
                              ),
                              Text(
                                'Manage your finances smartly',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  shadows: [Shadow(offset: Offset(0, 1), blurRadius: 3, color: Colors.black38)],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Choose Your Calculator',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          shadows: [Shadow(offset: Offset(0, 1), blurRadius: 3, color: Colors.black38)],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Calculator Cards
                      Expanded(
                        child: ListView(
                          children: [
                            _buildPremiumCard(
                              context: context,
                              title: 'Home Loan',
                              subtitle: 'Calculate mortgage payments\nand loan schedules',
                              icon: Icons.home_outlined,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                                stops: [0.0, 1.0],
                              ),
                              shadowColor: const Color(0xFF667eea),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation, secondaryAnimation) => const HomeLoanCalculatorPage(),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return SlideTransition(
                                        position: animation.drive(
                                          Tween(begin: const Offset(1.0, 0.0), end: Offset.zero),
                                        ),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),

                            _buildPremiumCard(
                              context: context,
                              title: 'Investment',
                              subtitle: 'Plan your investment returns\nand portfolio growth',
                              icon: Icons.trending_up_outlined,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                                stops: [0.0, 1.0],
                              ),
                              shadowColor: const Color(0xFF4facfe),
                              onTap: () {
                                _showComingSoonDialog(context, 'Investment Calculator');
                              },
                            ),
                            const SizedBox(height: 16),

                            _buildPremiumCard(
                              context: context,
                              title: 'Savings',
                              subtitle: 'Track your savings goals\nand compound interest',
                              icon: Icons.savings_outlined,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFFa8edea), Color(0xFFfed6e3)],
                                stops: [0.0, 1.0],
                              ),
                              shadowColor: const Color(0xFFa8edea),
                              onTap: () {
                                _showComingSoonDialog(context, 'Savings Calculator');
                              },
                            ),
                            const SizedBox(height: 16),

                            _buildPremiumCard(
                              context: context,
                              title: 'Retirement',
                              subtitle: 'Plan for your future\nand retirement needs',
                              icon: Icons.elderly_outlined,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFFffecd2), Color(0xFFfcb69f)],
                                stops: [0.0, 1.0],
                              ),
                              shadowColor: const Color(0xFFffecd2),
                              onTap: () {
                                _showComingSoonDialog(context, 'Retirement Planning');
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
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

  Widget _buildPremiumCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required LinearGradient gradient,
    required Color shadowColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: shadowColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8), spreadRadius: 0),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // Glassmorphism effect with better contrast
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.black.withOpacity(0.15), Colors.black.withOpacity(0.25)],
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      // Left content
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                                shadows: [Shadow(offset: Offset(0, 2), blurRadius: 4, color: Colors.black45)],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              subtitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                height: 1.4,
                                fontWeight: FontWeight.w500,
                                shadows: [Shadow(offset: Offset(0, 1), blurRadius: 3, color: Colors.black38)],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Right icon with animation effect
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                            ),
                            child: Icon(icon, size: 36, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Floating particles effect
                Positioned(
                  top: 20,
                  right: 20,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.6), shape: BoxShape.circle),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  right: 40,
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.4), shape: BoxShape.circle),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          content: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF9D50BB)]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.rocket_launch, color: Colors.white, size: 32),
                ),
                const SizedBox(height: 20),
                Text(
                  '$feature',
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'This feature is coming soon!\nStay tuned for updates.',
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: const Text('Got it!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
