import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../data/iso_helper.dart';
import '../data/level_data.dart';
import '../data/palette.dart';
import 'building.dart';

class IsoWorld extends PositionComponent {
  IsoWorld() : super(priority: -100);

  @override
  Future<void> onLoad() async {
    for (final b in LevelData.buildings) {
      final type = b['type'] as String;
      final colors = _colorsForType(type);
      add(Building(
        gx: b['x'] as int,
        gy: b['y'] as int,
        gw: b['w'] as int,
        gh: b['h'] as int,
        height: _heightForType(type),
        topColor: colors[0],
        leftColor: colors[1],
        rightColor: colors[2],
        label: b['label'] as String?,
      ));
    }
  }

  List<Color> _colorsForType(String type) {
    switch (type) {
      case 'cafe':
        return [Palette.buildingTopRed, Palette.buildingLeftRed, Palette.buildingRightRed];
      case 'market':
        return [Palette.buildingTopBlue, Palette.buildingLeftBlue, Palette.buildingRightBlue];
      case 'house':
      case 'shop':
      default:
        return [Palette.buildingTop, Palette.buildingLeft, Palette.buildingRight];
    }
  }

  double _heightForType(String type) {
    switch (type) {
      case 'market': return 50;
      case 'cafe':   return 40;
      case 'house':  return 65;
      default:       return 45;
    }
  }

  @override
  void render(Canvas canvas) {
    // الأرضيات
    final total = LevelData.cols + LevelData.rows;
    for (int sum = 0; sum <= total; sum++) {
      for (int gx = 0; gx < LevelData.cols; gx++) {
        final gy = sum - gx;
        if (gy < 0 || gy >= LevelData.rows) continue;
        final code = LevelData.bitashMap[gy][gx];
        if (code == 'B') continue;

        final pos = Iso.gridToScreen(gx.toDouble(), gy.toDouble());
        final color = LevelData.tileColor(code);

        final path = Iso.diamondPath(Iso.tileW, Iso.tileH);
        canvas.save();
        canvas.translate(pos.x, pos.y);
        canvas.drawPath(path, Paint()..color = color);
        canvas.drawPath(
          path,
          Paint()
            ..color = Colors.black.withOpacity(0.10)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
        canvas.restore();
      }
    }

    // النخل
    for (final p in LevelData.palms) {
      _drawPalm(canvas, p[0], p[1]);
    }
    // اللمبات
    for (final l in LevelData.lamps) {
      _drawLamp(canvas, l[0], l[1]);
    }
  }

  void _drawPalm(Canvas canvas, int gx, int gy) {
    final pos = Iso.gridToScreen(gx.toDouble(), gy.toDouble());
    canvas.save();
    canvas.translate(pos.x + Iso.tileW / 2, pos.y + Iso.tileH / 2);

    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 20, height: 8),
      Paint()..color = Palette.shadow,
    );
    canvas.drawRect(
      Rect.fromLTWH(-2, -30, 4, 30),
      Paint()..color = Palette.palmTrunk,
    );
    final leaf = Paint()..color = Palette.palmGreen;
    for (int i = 0; i < 5; i++) {
      final angle = (i - 2) * 0.5;
      canvas.save();
      canvas.translate(0, -30);
      canvas.rotate(angle);
      canvas.drawOval(
        Rect.fromCenter(center: const Offset(0, -10), width: 6, height: 20),
        leaf,
      );
      canvas.restore();
    }
    canvas.restore();
  }

  void _drawLamp(Canvas canvas, int gx, int gy) {
    final pos = Iso.gridToScreen(gx.toDouble(), gy.toDouble());
    canvas.save();
    canvas.translate(pos.x + Iso.tileW / 2, pos.y + Iso.tileH / 2);

    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 10, height: 4),
      Paint()..color = Palette.shadow,
    );
    canvas.drawRect(
      Rect.fromLTWH(-1, -28, 2, 28),
      Paint()..color = Palette.lampPost,
    );
    canvas.drawCircle(
      const Offset(0, -30),
      4,
      Paint()..color = const Color(0xFFFFE88A),
    );
    canvas.restore();
  }
}