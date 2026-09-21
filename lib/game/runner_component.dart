import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../models/runner_hero.dart';

/// Placeholder circle sprite until hero art is wired in via
/// SpriteAnimationComponent.
class RunnerComponent extends CircleComponent with HasGameReference {
  RunnerComponent({
    required this.hero,
    required this.joystick,
    required Vector2 position,
  }) : super(
          radius: 16,
          position: position,
          anchor: Anchor.center,
          paint: Paint()..color = Colors.brown,
        );

  final RunnerHero hero;
  final JoystickComponent joystick;

  @override
  void update(double dt) {
    super.update(dt);
    if (!joystick.delta.isZero()) {
      position += joystick.relativeDelta * hero.baseSpeed * dt;
    }
  }
}
