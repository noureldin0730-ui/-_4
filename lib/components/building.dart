import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../data/iso_helper.dart';
import '../data/palette.dart';

class Building extends PositionComponent {
  final int gx;
  final int gy;
  final int gw;
  final int gh;
  final double height;
  final Color topColor;
  final Color leftColor;
  final Color rightColor;
  final String? label;

  Building({
    required this.gx,
    required this.gy,
    this.gw = 1,
    this.gh = 1,
    this.height = 60,
    required this.topColor,
    required this.leftColor,
    required this.rightColor,
    this.label,
  }) : super(priority: (gx + gy) * 10);

  @override
  void render(Canvas canvas) {
    // مركز المبنى في الـ grid
    final centerGx = gx + (gw - 1) / 2.0;
    final centerGy = gy + (gh - 1) / 2.0;
    final base = Iso.gridToScreen(centerGx, centerGy);

    // نصف عرض/ارتفاع القاعدة
    final halfW = (Iso.tileW / 2) * gw;
    final halfH = (Iso.tileH / 2) * gh;

    canvas.save();

    // ظل المبنى
    final shadowPath = Path()
      ..moveTo(base.x, base.y - halfH)
      ..lineTo(base.x + halfW, base.y)
      ..lineTo(base.x, base.y + halfH)
      ..lineTo(base.x - halfW, base.y)
      ..close();
    canvas.drawPath(shadowPath, Paint()..color = Palette.shadow);

    // المبنى
    Iso.drawIsoBox(
      canvas,
      base,
      halfW,
      halfH,
      height,
      topColor,
      leftColor,
      rightColor,
    );

    // اللافتة فوق المبنى
    if (label != null && label!.isNotEmpty) {
      _drawLabel(canvas, base.x, base.y - height - halfH - 12);
    }

    canvas.restore();
  }

  void _drawLabel(Canvas canvas, double cx, double cy) {
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Palette.signText,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    const padX = 6.0;
    const padY = 3.0;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        cx - tp.width / 2 - padX,
        cy - tp.height / 2 - padY,
        tp.width + padX * 2,
        tp.height + padY * 2,
      ),
      const Radius.circular(3),
    );
    canvas.drawRRect(rect, Paint()..color = Palette.signboard);
    canvas.drawRRect(
      rect,
      Paint()
        ..color = Palette.signText
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));
  }
}