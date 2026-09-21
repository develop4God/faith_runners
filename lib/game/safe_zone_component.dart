import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// The match's win condition: reach this rectangle before the timer runs out.
class SafeZoneComponent extends RectangleComponent {
  SafeZoneComponent({required Vector2 position, required Vector2 size})
      : super(
          position: position,
          size: size,
          paint: Paint()..color = const Color(0xFF8FD19E).withValues(alpha: 0.6),
        );
}
