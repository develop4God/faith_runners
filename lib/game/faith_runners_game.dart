import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../models/runner_hero.dart';
import 'runner_component.dart';

/// V1 shell: single local runner on an empty arena, movable with a
/// joystick, to prove the render/input pipeline before hero art and
/// map tiles are wired in.
class FaithRunnersGame extends FlameGame with HasKeyboardHandlerComponents {
  late final JoystickComponent joystick;
  late final RunnerComponent player;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    joystick = JoystickComponent(
      knob: CircleComponent(radius: 20, paint: Paint()..color = Colors.white54),
      background: CircleComponent(radius: 50, paint: Paint()..color = Colors.white24),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );

    player = RunnerComponent(
      hero: kRunnerRoster.first,
      joystick: joystick,
      position: size / 2,
    );

    addAll([joystick, player]);
  }

  @override
  Color backgroundColor() => const Color(0xFFF4E3C1);
}
