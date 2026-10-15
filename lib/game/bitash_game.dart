import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../components/iso_world.dart';
import '../components/station.dart';
import '../components/vehicle.dart';
import '../data/level_data.dart';

enum GameStatus { playing, finished }

class BitashGame extends FlameGame with DragCallbacks, TapCallbacks {
  final VehicleType vehicleType;
  final void Function(GameStatus status) onStatusChange;

  late Vehicle vehicle;
  final List<Station> stations = [];

  int money = 0;
  int delivered = 0;
  int totalStations = 0;

  GameStatus _status = GameStatus.playing;

  BitashGame({
    required this.vehicleType,
    required this.onStatusChange,
  });

  @override
  Color backgroundColor() => const Color(0xFF7AC0E8);

  @override
  Future<void> onLoad() async {
    // 1. العالم
    add(IsoWorld());

    // 2. المحطات والزباين
    for (final s in LevelData.stations) {
      final station = Station(
        gx: s['x'] as int,
        gy: s['y'] as int,
        name: s['name'] as String,
        color: Color(s['color'] as int),
      );
      stations.add(station);
      add(station);
    }
    totalStations = stations.length;

    // 3. العربية
    vehicle = Vehicle(
      type: vehicleType,
      gx: LevelData.playerStartX.toDouble(),
      gy: LevelData.playerStartY.toDouble(),
    );
    add(vehicle);

    // 4. الكاميرا تتبع العربية
    camera.follow(vehicle);
    camera.viewfinder.anchor = Anchor.center;
    camera.viewfinder.zoom = 1.2;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_status != GameStatus.playing) return;

    // استقبال الزبون
    if (vehicle.isIdle && vehicle.hasSpace) {
      for (final station in stations) {
        final p = station.passenger;
        if (p == null) continue;
        if (p.state.name != 'waiting') continue;

        final dx = station.gx - vehicle.gx;
        final dy = station.gy - vehicle.gy;
        if (dx.abs() < 0.5 && dy.abs() < 0.5) {
          vehicle.pickUp('p_${station.gx}_${station.gy}');
          p.ride();
        }
      }
    }

    // توصيل الزبون
    if (vehicle.passengers.isNotEmpty) {
      for (final station in stations) {
        final p = station.passenger;
        if (p == null) continue;
        if (p.state.name == 'waiting') continue;
        if (p.state.name == 'delivered') continue;

        final id = 'p_${station.gx}_${station.gy}';
        if (vehicle.passengers.contains(id)) {
          final dx = station.gx - vehicle.gx;
          final dy = station.gy - vehicle.gy;
          if (dx.abs() < 0.5 && dy.abs() < 0.5) {
            vehicle.dropOff(id);
            money += vehicleType == VehicleType.tuktuk ? 20 : 10;
            delivered++;
            p.deliver();
          }
        }
      }
    }

    if (delivered >= totalStations) {
      _finish();
    }
  }

  void _finish() {
    if (_status == GameStatus.finished) return;
    _status = GameStatus.finished;
    onStatusChange(GameStatus.finished);
  }

  Vector2? _dragStart;

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    _dragStart = event.localPosition.clone();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (_dragStart == null) return;

    final current = event.localEndPosition;
    final dx = current.x - _dragStart!.x;
    final dy = current.y - _dragStart!.y;

    if (dx.abs() < 40 && dy.abs() < 40) return;

    int tx = vehicle.gx.floor();
    int ty = vehicle.gy.floor();

    if (dx.abs() > dy.abs()) {
      if (dx > 0) { tx += 1; } else { tx -= 1; }
    } else {
      if (dy > 0) { ty += 1; } else { ty -= 1; }
    }

    vehicle.moveTo(tx, ty);
    _dragStart = current.clone();
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _dragStart = null;
  }
}