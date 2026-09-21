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
///
/// The arena is a fixed landscape (wide) world, letterboxed to fit any
/// screen shape via a fixed-resolution camera — so it always renders wide,
/// even on a portrait phone screen or a browser tab that can't honor an
/// orientation lock.
class FaithRunnersGame extends FlameGame with HasKeyboardHandlerComponents {
  static const double worldWidth = 800;
  static const double worldHeight = 450;
  static const double matchSeconds = 20;

  FaithRunnersGame()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: worldWidth,
            height: worldHeight,
          ),
        );

  late final JoystickComponent joystick;
  late final RunnerComponent player;
  late final SafeZoneComponent safeZone;
  late final SearchPartyHazard hazard;

  MatchState matchState = MatchState.playing;
  double timeRemaining = matchSeconds;
  late Vector2 _startPosition;

  /// True once [player] and friends are safe to read from outside the
  /// game loop (e.g. from a Flutter overlay's StreamBuilder), avoiding a
  /// LateInitializationError race against the async work in [onLoad].
  bool isReady = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // withFixedResolution's viewfinder defaults to centering the camera on
    // world-position (0,0). Our world is laid out with (0,0) as the
    // top-left corner (matching how every component below is positioned),
    // so the viewfinder must be re-centered on the middle of that world —
    // otherwise the camera shows the wrong region and content appears
    // cropped/shifted.
    camera.viewfinder.position = Vector2(worldWidth / 2, worldHeight / 2);

    joystick = JoystickComponent(
      knob: CircleComponent(radius: 20, paint: Paint()..color = Colors.white54),
      background: CircleComponent(radius: 50, paint: Paint()..color = Colors.white24),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );

    safeZone = SafeZoneComponent(
      position: Vector2(0, 0),
      size: Vector2(worldWidth, 90),
    );

    hazard = SearchPartyHazard(
      arenaWidth: worldWidth,
      bandHeight: 70,
      y: worldHeight * 0.45,
    );

    _startPosition = Vector2(worldWidth / 2, worldHeight - 80);
    player = RunnerComponent(
      hero: kRunnerRoster.first,
      joystick: joystick,
      position: _startPosition.clone(),
      arenaSize: Vector2(worldWidth, worldHeight),
    );

    await world.addAll([safeZone, hazard, player]);
    await add(joystick);
    isReady = true;
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
    player.resetAbilityState();
  }

  @override
  Color backgroundColor() => const Color(0xFFF4E3C1);
}
