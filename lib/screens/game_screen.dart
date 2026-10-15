import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../components/vehicle.dart';
import '../game/bitash_game.dart';
import 'menu_screen.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  final VehicleType vehicleType;
  const GameScreen({super.key, required this.vehicleType});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late BitashGame _game;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _buildGame();
  }

  void _buildGame() {
    _navigated = false;
    _game = BitashGame(
      vehicleType: widget.vehicleType,
      onStatusChange: _onStatus,
    );
  }

  void _onStatus(GameStatus status) {
    if (_navigated) return;
    _navigated = true;

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            vehicleType: widget.vehicleType,
            delivered: _game.delivered,
            total: _game.totalStations,
            money: _game.money,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // اللعبة
          GameWidget(game: _game),

          // HUD — فوق
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ValueListenableBuilder<int>(
                    valueListenable: _moneyNotifier,
                    builder: (_, __, ___) => const SizedBox(),
                  ),
                  _hudChip(
                    '💰',
                    '${_game.money} ج',
                    const Color(0xFFFFD54A),
                  ),
                  _hudChip(
                    '👥',
                    '${_game.delivered}/${_game.totalStations}',
                    const Color(0xFF7AD77A),
                  ),
                  _hudChip(
                    widget.vehicleType == VehicleType.tuktuk ? '🛺' : '🚐',
                    'البيطاش',
                    const Color(0xFF7AD7FF),
                  ),
                ],
              ),
            ),
          ),

          // زرار EXIT
          Positioned(
            top: 12,
            left: 0,
            right: 0,
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const MenuScreen()),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      border: Border.all(color: const Color(0xFF7AD7FF)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'EXIT',
                      style: TextStyle(
                        color: Color(0xFF7AD7FF),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // تلميح التحكم (يختفي بعد شوية)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'اسحب للتحرك  •  قف على الزبون يركب  •  وديه لمحطة تانية',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _hudChip(String icon, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.7), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 15)),
          const SizedBox(width: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// notifier فاضي — بس عشان الـ ValueListenableBuilder
final ValueNotifier<int> _moneyNotifier = ValueNotifier<int>(0);