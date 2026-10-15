import 'package:flutter/material.dart';

import '../components/vehicle.dart';
import 'game_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.65, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _startGame(VehicleType type) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GameScreen(vehicleType: type),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7AC0E8), // سما
              Color(0xFF4A90C2), // بحر
              Color(0xFF1A1410), // رمل داكن
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // عنوان
              Align(
                alignment: const Alignment(0, -0.7),
                child: AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (_, __) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "مشروع البيطاش",
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFFFFD54A),
                            letterSpacing: 3,
                            shadows: [
                              Shadow(
                                color: const Color(0xFFFFCC00).withOpacity(_pulseAnim.value),
                                blurRadius: 20,
                              ),
                              const Shadow(
                                color: Color(0xFF8A6000),
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "NOUR'S RIDE: EL-BITASH",
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF1A1410),
                            letterSpacing: 3,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // اختيار المركبة
              Align(
                alignment: const Alignment(0, 0.2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _vehicleCard(
                      type: VehicleType.tuktuk,
                      title: 'توك توك',
                      subtitle: 'سريع • زبون واحد • 20 جنيه',
                      emoji: '🛺',
                      color: const Color(0xFFFFCC00),
                    ),
                    const SizedBox(width: 20),
                    _vehicleCard(
                      type: VehicleType.microbus,
                      title: 'ميكروباص',
                      subtitle: '7 زباين • 10 جنيه للفرد',
                      emoji: '🚐',
                      color: const Color(0xFF2A6BAA),
                    ),
                  ],
                ),
              ),

              // اسمك
              const Positioned(
                bottom: 14,
                left: 0,
                right: 0,
                child: Text(
                  'A GAME BY NOUR ELDIN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xCC1A1410),
                    fontSize: 11,
                    letterSpacing: 4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _vehicleCard({
    required VehicleType type,
    required String title,
    required String subtitle,
    required String emoji,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _startGame(type),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 180,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.35),
            border: Border.all(color: color, width: 2.5),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.45),
                blurRadius: 18,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 46)),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}