import 'package:flutter/material.dart';

import '../components/vehicle.dart';
import 'game_screen.dart';
import 'menu_screen.dart';

class ResultScreen extends StatefulWidget {
  final VehicleType vehicleType;
  final int delivered;
  final int total;
  final int money;

  const ResultScreen({
    super.key,
    required this.vehicleType,
    required this.delivered,
    required this.total,
    required this.money,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _retry() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => GameScreen(vehicleType: widget.vehicleType),
      ),
    );
  }

  void _menu() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MenuScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isComplete = widget.delivered >= widget.total;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isComplete
                ? [const Color(0xFF1A4A2A), const Color(0xFF1A1410)]
                : [const Color(0xFF4A2A1A), const Color(0xFF1A1410)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: ScaleTransition(
                scale: _scaleAnim,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isComplete ? '🏆' : '🛺',
                      style: const TextStyle(fontSize: 60),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isComplete ? 'خلصت المشوار!' : 'لسه فيه زباين!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: isComplete
                            ? const Color(0xFF7AD77A)
                            : const Color(0xFFFFAA33),
                        letterSpacing: 3,
                        shadows: [
                          Shadow(
                            color: isComplete
                                ? const Color(0xFF1A8A3A)
                                : const Color(0xFF8A5A00),
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.vehicleType == VehicleType.tuktuk
                          ? 'توك توك البيطاش'
                          : 'ميكروباص البيطاش',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 26),

                    // إحصائيات
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 26, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        border: Border.all(
                          color: (isComplete
                                  ? const Color(0xFF7AD77A)
                                  : const Color(0xFFFFAA33))
                              .withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _statRow(
                            'الزباين اللي وصلتهم',
                            '${widget.delivered}/${widget.total}',
                          ),
                          const SizedBox(height: 8),
                          const Divider(color: Colors.white24, height: 18),
                          _statRow(
                            'الفلوس',
                            '${widget.money} ج',
                            highlight: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 26),

                    // أزرار
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _btn(
                          'حاول تاني',
                          const Color(0xFFFFD54A),
                          _retry,
                        ),
                        const SizedBox(width: 12),
                        _btn(
                          'القائمة',
                          const Color(0xFF7AD7FF),
                          _menu,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    const Text(
                      'A GAME BY NOUR ELDIN',
                      style: TextStyle(
                        color: Color(0x55FFFFFF),
                        fontSize: 10,
                        letterSpacing: 4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statRow(String label, String value, {bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(width: 30),
        Text(
          value,
          style: TextStyle(
            color: highlight
                ? const Color(0xFFFFD54A)
                : const Color(0xFF7AD77A),
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _btn(String label, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 130,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}