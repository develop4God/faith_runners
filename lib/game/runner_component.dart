import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import '../models/runner_hero.dart';

enum _RunnerAnim { idle, running, ability }

/// David's real art wired in: idle when still, run-cycle animation while
/// the joystick is pushed (mirrored to face travel direction), and his
/// ability pose during the sling dash.
class RunnerComponent extends SpriteAnimationGroupComponent<_RunnerAnim>
    with HasGameReference {
  RunnerComponent({
    required this.hero,
    required this.joystick,
    required Vector2 position,
  }) : super(
          size: Vector2(56, 120),
          position: position,
          anchor: Anchor.center,
        );

  static const double _dashDistance = 90;

  final RunnerHero hero;
  final JoystickComponent joystick;

  bool _facingLeft = false;
  Vector2 _facingDirection = Vector2(1, 0);

  double _abilityTimeRemaining = 0;
  double _abilityCooldownRemaining = 0;

  bool get abilityReady => _abilityCooldownRemaining <= 0;
  double get abilityCooldownFraction =>
      (_abilityCooldownRemaining / hero.ability.cooldownSeconds).clamp(0, 1);

  void resetAbilityState() {
    _abilityTimeRemaining = 0;
    _abilityCooldownRemaining = 0;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final idleSprite = await Sprite.load('heroes/david_idle.png');
    final abilitySprite = await Sprite.load('heroes/david_ability_pose.png');
    final runImage = await game.images.load('heroes/david_run_cycle.png');
    final runSheet = SpriteSheet(image: runImage, srcSize: Vector2(169, 369));

    animations = {
      _RunnerAnim.idle: SpriteAnimation.spriteList([idleSprite], stepTime: 1),
      _RunnerAnim.running: runSheet.createAnimation(row: 0, stepTime: 0.12),
      _RunnerAnim.ability: SpriteAnimation.spriteList([abilitySprite], stepTime: 1),
    };
    current = _RunnerAnim.idle;
  }

  /// David's sling dash: an instant burst in the direction he's facing.
  /// Returns false (no-op) while on cooldown.
  bool tryActivateAbility() {
    if (!abilityReady) return false;

    _abilityTimeRemaining = hero.ability.durationSeconds;
    _abilityCooldownRemaining = hero.ability.cooldownSeconds;

    final target = position + _facingDirection * _dashDistance;
    position = Vector2(
      target.x.clamp(0, game.size.x),
      target.y.clamp(0, game.size.y),
    );
    return true;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_abilityCooldownRemaining > 0) {
      _abilityCooldownRemaining = (_abilityCooldownRemaining - dt).clamp(0, double.infinity);
    }

    if (_abilityTimeRemaining > 0) {
      _abilityTimeRemaining -= dt;
      current = _RunnerAnim.ability;
      return;
    }

    final moving = !joystick.delta.isZero();
    current = moving ? _RunnerAnim.running : _RunnerAnim.idle;

    if (moving) {
      position += joystick.relativeDelta * hero.baseSpeed * dt;
      _facingDirection = joystick.relativeDelta.normalized();

      final movingLeft = joystick.relativeDelta.x < 0;
      if (movingLeft != _facingLeft) {
        _facingLeft = movingLeft;
        flipHorizontallyAroundCenter();
      }
    }
  }
}
