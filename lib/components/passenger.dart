import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import '../data/iso_helper.dart';
import '../data/palette.dart';

enum PassengerState { waiting, riding, delivered }

/// ============================================================
/// PASSENGER — زبون بيستخدم صور Kenney الحقيقية
/// 3 tilesheets:
///   female_tilesheet.png  → الستات
///   player_tilesheet.png  → الرجالة (أخضر)
///   soldier_tilesheet.png → الرجالة بلحية
/// كل tilesheet فيه 27 sprite (3 صفوف × 9)
/// ============================================================
class Passenger extends PositionComponent {
  final int gx;
  final int gy;
  final int variant; // 0=female, 1=player, 2=soldier

  PassengerState state = PassengerState.waiting;
  double t = 0;

  // الصورة اللي هتتحمل
  Sprite? _sprite;

  static const double spriteW = 64.0;
  static const double spriteH = 64.0;

  Passenger({
    required this.gx,
    required this.gy,
    this.variant = 0,
  }) : super(priority: 100);

  @override
  Future<void> onLoad() async {
    // نحمّل الصورة حسب الـ variant
    String path;
    switch (variant) {
      case 1:  path = 'player_tilesheet.png'; break;
      case 2:  path = 'soldier_tilesheet.png'; break;
      default: path = 'female_tilesheet.png';
    }

    final image = await Flame.images.load(
      'assets/images/characters/$path',
      key: path,
    );

    // ناخد أول sprite من الـ sheet (اللي هو "واقف" mid row)
    // الـ sheet 9 cols × 3 rows، كل sprite = عرض/9 × طول/3
    final frameW = image.width / 9;
    final frameH = image.height / 3;

    // نختار صف 1 (الوسط) — عادةً الصف ده فيه "واقف"
    final row = 1;
    final col = math.Random().nextInt(9);

    _sprite = Sprite(
      image,
      srcPosition: Vector2(col * frameW, row * frameH),
      srcSize: Vector2(frameW, frameH),
    );
  }

  @override
  void update(double dt) {
    t += dt;
  }

  void ride() {
    state = PassengerState.riding;
    removeFromParent();
  }

  void deliver() {
    state = PassengerState.delivered;
    removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    if (state != PassengerState.waiting) return;

    final pos = Iso.gridToScreen(gx.toDouble(), gy.toDouble());
    canvas.save();
    canvas.translate(pos.x + Iso.tileW / 2, pos.y + Iso.tileH / 2);

    // ظل
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, 10), width: 22, height: 8),
      Paint()..color = Palette.shadow,
    );

    // الصورة
    if (_sprite != null) {
      // نرسم الـ sprite بحجم 48×48، مركزها فوق نقطة الـ grid
      _sprite!.render(
        canvas,
        position: Vector2(-spriteW / 2, -spriteH + 8),
        size: Vector2(spriteW, spriteH),
      );
    } else {
      // fallback — دايرة بسيطة لحد ما الصورة تتحمل
      canvas.drawCircle(
        const Offset(0, -8),
        10,
        Paint()..color = const Color(0xFFE8B888),
      );
    }

    // علامة "!" نابضة فوق الراس
    final bob = math.sin(t * 4) * 3;
    _drawExclamation(canvas, 0, -spriteH - 4 + bob);

    canvas.restore();
  }

  void _drawExclamation(Canvas canvas, double x, double y) {
    canvas.drawCircle(
      Offset(x, y),
      9,
      Paint()..color = Palette.hudGold,
    );
    canvas.drawCircle(
      Offset(x, y),
      9,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    final tp = TextPainter(
      text: const TextSpan(
        text: '!',
        style: TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));
  }
}