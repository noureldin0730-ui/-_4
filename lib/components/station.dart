import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../data/iso_helper.dart';
import '../data/palette.dart';
import 'passenger.dart';

/// ============================================================
/// STATION — محطة زباين
/// علامة على الأرض + زبون واقف فوقيها
/// الزبون بياخد variant عشوائي (0=female, 1=player, 2=soldier)
/// ============================================================
class Station extends PositionComponent {
  final int gx;
  final int gy;
  final String name;
  final Color color;

  Passenger? passenger;
  double t = 0;

  Station({
    required this.gx,
    required this.gy,
    required this.name,
    required this.color,
  }) : super(priority: (gx + gy) * 10 + 5);

  @override
  void onLoad() {
    // زبون بـ variant عشوائي (0, 1, 2)
    passenger = Passenger(
      gx: gx,
      gy: gy,
      variant: math.Random().nextInt(3),
    );
    add(passenger!);
  }

  @override
  void update(double dt) {
    t += dt;
  }

  @override
  void render(Canvas canvas) {
    final pos = Iso.gridToScreen(gx.toDouble(), gy.toDouble());
    canvas.save();
    canvas.translate(pos.x, pos.y);

    final cx = Iso.tileW / 2;
    final cy = Iso.tileH / 2;

    // دايرة خارجية نابضة
    final pulse = 1.0 + math.sin(t * 3) * 0.1;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, cy),
        width: 34 * pulse,
        height: 17 * pulse,
      ),
      Paint()..color = color.withOpacity(0.3),
    );

    // دايرة داخلية
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, cy),
        width: 22,
        height: 11,
      ),
      Paint()..color = color,
    );

    // حد داكن
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, cy),
        width: 22,
        height: 11,
      ),
      Paint()
        ..color = Palette.shadow
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    canvas.restore();
  }
}