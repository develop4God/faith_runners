import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../models/runner_hero.dart';
import 'match_state.dart';
import 'runner_component.dart';
import 'safe_zone_component.dart';
import 'search_party_hazard.dart';

/// Sprint 1 slice: "Flight to Egypt" — reach the safe zone before the
/// search party's sweep catches you, before the timer runs out. Touching
/// the hazard is a setback (reset to start), never elimination.
class FaithRunnersGame extends FlameGame with HasKeyboardHandlerComponents {
  static const double matchSeconds = 20;

  late final JoystickComponent joystick;
  late final RunnerComponent player;
  late final SafeZoneComponent safeZone;
  late final SearchPartyHazard hazard;

  MatchState matchState = MatchState.playing;
  double timeRemaining = matchSeconds;
  late Vector2 _startPosition;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    joystick = JoystickComponent(
      knob: CircleComponent(radius: 20, paint: Paint()..color = Colors.white54),
      background: CircleComponent(radius: 50, paint: Paint()..color = Colors.white24),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );

    safeZone = SafeZoneComponent(
      position: Vector2(0, 0),
      size: Vector2(size.x, 90),
    );

    hazard = SearchPartyHazard(
      arenaWidth: size.x,
      bandHeight: 70,
      y: size.y * 0.45,
    );

    _startPosition = Vector2(size.x / 2, size.y - 120);
    player = RunnerComponent(
      hero: kRunnerRoster.first,
      joystick: joystick,
      position: _startPosition.clone(),
    );

    addAll([safeZone, hazard, joystick, player]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (matchState != MatchState.playing) return;

    timeRemaining -= dt;
    if (timeRemaining <= 0) {
      timeRemaining = 0;
      _endMatch(MatchState.lost);
      return;
    }

    if (safeZone.toRect().overlaps(player.toRect())) {
      _endMatch(MatchState.won);
      return;
    }

    if (hazard.toRect().overlaps(player.toRect())) {
      player.position = _startPosition.clone();
    }
  }

  void _endMatch(MatchState result) {
    matchState = result;
    overlays.add(result == MatchState.won ? 'win' : 'lose');
  }

  void restart() {
    overlays.remove(matchState == MatchState.won ? 'win' : 'lose');
    matchState = MatchState.playing;
    timeRemaining = matchSeconds;
    player.position = _startPosition.clone();
  }

  @override
  Color backgroundColor() => const Color(0xFFF4E3C1);
}
