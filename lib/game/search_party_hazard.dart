import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// A sweeping band that patrols left-right across the arena. Touching it
/// sends the runner back to the start — a setback, never an elimination.
class SearchPartyHazard extends RectangleComponent {
  SearchPartyHazard({
    required this.arenaWidth,
    required double bandHeight,
    required double y,
  }) : super(
          size: Vector2(160, bandHeight),
          position: Vector2(0, y),
          paint: Paint()..color = Colors.black.withValues(alpha: 0.35),
        );

  final double arenaWidth;
  double _direction = 1;
  static const double _speed = 90;

  @override
  void update(double dt) {
    super.update(dt);
    position.x += _direction * _speed * dt;
    if (position.x <= 0 || position.x + size.x >= arenaWidth) {
      _direction *= -1;
    }
  }
}
