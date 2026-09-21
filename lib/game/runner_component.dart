import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import '../models/runner_hero.dart';

enum _RunnerAnim { idle, running, ability }

/// David's real art wired in: idle when still, run-cycle animation while
/// the joystick is pushed (mirrored to face travel direction), and his
/// ability pose during the sling dash.
///
/// The idle, running, and ability art have different native aspect ratios
/// (idle is a tall/thin standing pose; the run cycle is a wider mid-stride
/// crop). [_visual] is a child sized to whichever animation's own aspect
/// ratio at a fixed height, so switching animations never stretches the
/// art — only [RunnerComponent] itself keeps a fixed size, since that's
/// also the hitbox used for collision.
class RunnerComponent extends PositionComponent with HasGameReference {
  RunnerComponent({
    required this.hero,
    required this.joystick,
    required Vector2 position,
    required this.arenaSize,
  }) : super(
          size: Vector2(59, 120),
          position: position,
          anchor: Anchor.center,
        );

  static const double _renderHeight = 120;
  static const double _dashDistance = 90;

  final _RunnerVisual _visual = _RunnerVisual(renderHeight: _renderHeight);

  final RunnerHero hero;
  final JoystickComponent joystick;

  /// Bounds of the fixed-resolution world (not the device screen), used to
  /// clamp the dash so David can't be flung outside the arena.
  final Vector2 arenaSize;

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
    await add(_visual..anchor = Anchor.center);
    _visual.position = size / 2;
  }

  /// David's sling dash: an instant burst in the direction he's facing.
  /// Returns false (no-op) while on cooldown.
  bool tryActivateAbility() {
    if (!abilityReady) return false;

    _abilityTimeRemaining = hero.ability.durationSeconds;
    _abilityCooldownRemaining = hero.ability.cooldownSeconds;

    final target = position + _facingDirection * _dashDistance;
    position = Vector2(
      target.x.clamp(0, arenaSize.x),
      target.y.clamp(0, arenaSize.y),
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
      _visual.current = _RunnerAnim.ability;
      return;
    }

    final moving = !joystick.delta.isZero();
    _visual.current = moving ? _RunnerAnim.running : _RunnerAnim.idle;

    if (moving) {
      position += joystick.relativeDelta * hero.baseSpeed * dt;
      _facingDirection = joystick.relativeDelta.normalized();

      final movingLeft = joystick.relativeDelta.x < 0;
      if (movingLeft != _facingLeft) {
        _facingLeft = movingLeft;
        _visual.flipHorizontallyAroundCenter();
      }
    }
  }
}

/// Renders David's current animation at a fixed height, resizing its width
/// to match each sprite's own aspect ratio so switching between the tall
/// idle pose and the wider run-cycle frames never stretches the art.
class _RunnerVisual extends SpriteAnimationGroupComponent<_RunnerAnim>
    with HasGameReference {
  _RunnerVisual({required this.renderHeight});

  final double renderHeight;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final idleSprite = await Sprite.load('heroes/david_idle.png');
    final abilitySprite = await Sprite.load('heroes/david_ability_pose.png');
    final runImage = await game.images.load('heroes/david_run_cycle.png');
    final runSheet = SpriteSheet(image: runImage, srcSize: Vector2(162, 171));

    animations = {
      _RunnerAnim.idle: SpriteAnimation.spriteList([idleSprite], stepTime: 1),
      _RunnerAnim.running: runSheet.createAnimation(row: 0, stepTime: 0.12),
      _RunnerAnim.ability: SpriteAnimation.spriteList([abilitySprite], stepTime: 1),
    };
    current = _RunnerAnim.idle;
    _syncSizeToCurrentSprite();
  }

  @override
  set current(_RunnerAnim? value) {
    super.current = value;
    _syncSizeToCurrentSprite();
  }

  void _syncSizeToCurrentSprite() {
    final sprite = animationTicker?.getSprite();
    if (sprite == null) return;
    final aspectRatio = sprite.srcSize.x / sprite.srcSize.y;
    size = Vector2(renderHeight * aspectRatio, renderHeight);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _syncSizeToCurrentSprite();
  }
}
