import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// ============================================================
/// ISO HELPER — النسخة الصح
/// ============================================================
class Iso {
  static const double tileW = 64.0;
  static const double tileH = 32.0;

  static Vector2 gridToScreen(double gx, double gy) {
    final sx = (gx - gy) * (tileW / 2);
    final sy = (gx + gy) * (tileH / 2);
    return Vector2(sx, sy);
  }

  static Vector2 screenToGrid(double sx, double sy) {
    final gx = (sx / (tileW / 2) + sy / (tileH / 2)) / 2;
    final gy = (sy / (tileH / 2) - sx / (tileW / 2)) / 2;
    return Vector2(gx, gy);
  }

  static Path diamondPath(double w, double h) {
    return Path()
      ..moveTo(w / 2, 0)
      ..lineTo(w, h / 2)
      ..lineTo(w / 2, h)
      ..lineTo(0, h / 2)
      ..close();
  }

  /// ============================================================
  /// ISO BOX — المبنى
  /// base = مركز القاعدة في العالم
  /// halfW = نصف عرض البلاطة × عدد الـ tiles
  /// halfH = نصف ارتفاع البلاطة × عدد الـ tiles
  /// ============================================================
  static void drawIsoBox(
    Canvas canvas,
    Vector2 base,
    double halfW,
    double halfH,
    double height,
    Color topColor,
    Color leftColor,
    Color rightColor,
  ) {
    // نقاط القاعدة
    final top    = Offset(base.x, base.y - halfH);
    final right  = Offset(base.x + halfW, base.y);
    final bottom = Offset(base.x, base.y + halfH);
    final left   = Offset(base.x - halfW, base.y);

    // نقاط السطح (مرفوعة بـ height)
    final tTop    = Offset(top.dx, top.dy - height);
    final tRight  = Offset(right.dx, right.dy - height);
    final tBottom = Offset(bottom.dx, bottom.dy - height);
    final tLeft   = Offset(left.dx, left.dy - height);

    // الوش اليمين
    final rightFace = Path()
      ..moveTo(right.dx, right.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..lineTo(tBottom.dx, tBottom.dy)
      ..lineTo(tRight.dx, tRight.dy)
      ..close();
    canvas.drawPath(rightFace, Paint()..color = rightColor);

    // الوش الشمال
    final leftFace = Path()
      ..moveTo(left.dx, left.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..lineTo(tBottom.dx, tBottom.dy)
      ..lineTo(tLeft.dx, tLeft.dy)
      ..close();
    canvas.drawPath(leftFace, Paint()..color = leftColor);

    // السطح
    final topFace = Path()
      ..moveTo(tTop.dx, tTop.dy)
      ..lineTo(tRight.dx, tRight.dy)
      ..lineTo(tBottom.dx, tBottom.dy)
      ..lineTo(tLeft.dx, tLeft.dy)
      ..close();
    canvas.drawPath(topFace, Paint()..color = topColor);

    // الحدود
    final edge = Paint()
      ..color = Colors.black.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawPath(rightFace, edge);
    canvas.drawPath(leftFace, edge);
    canvas.drawPath(topFace, edge);
  }
}