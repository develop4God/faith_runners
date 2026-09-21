import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import '../models/runner_hero.dart';

enum _RunnerAnim { idle, running }

/// David's real art wired in: idle when still, run-cycle animation while
/// the joystick is pushed, mirrored to face the direction of travel.
class RunnerComponent extends SpriteAnimationGroupComponent<_RunnerAnim>
    with HasGameReference {
  RunnerComponent({
    required this.hero,
    required this.joystick,
    required Vector2 position,
  }) : super(
          size: Vector2(30, 64),
          position: position,
          anchor: Anchor.center,
        );

  final RunnerHero hero;
  final JoystickComponent joystick;

  bool _facingLeft = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final idleSprite = await Sprite.load('heroes/david_idle.png');
    final runImage = await game.images.load('heroes/david_run_cycle.png');
    final runSheet = SpriteSheet(image: runImage, srcSize: Vector2(169, 369));

    animations = {
      _RunnerAnim.idle: SpriteAnimation.spriteList([idleSprite], stepTime: 1),
      _RunnerAnim.running: runSheet.createAnimation(row: 0, stepTime: 0.12),
    };
    current = _RunnerAnim.idle;
  }

  @override
  void update(double dt) {
    super.update(dt);

    final moving = !joystick.delta.isZero();
    current = moving ? _RunnerAnim.running : _RunnerAnim.idle;

    if (moving) {
      position += joystick.relativeDelta * hero.baseSpeed * dt;

      final movingLeft = joystick.relativeDelta.x < 0;
      if (movingLeft != _facingLeft) {
        _facingLeft = movingLeft;
        flipHorizontallyAroundCenter();
      }
    }
  }
}
