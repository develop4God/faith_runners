@Tags(['unit'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:faith_runners/models/runner_hero.dart';

void main() {
  group('kRunnerRoster', () {
    test('has exactly the 5 launch heroes', () {
      expect(kRunnerRoster.length, 5);
    });

    test('every hero has a unique id', () {
      final ids = kRunnerRoster.map((h) => h.id).toSet();
      expect(ids.length, kRunnerRoster.length);
    });

    test('every hero has a positive base speed', () {
      for (final hero in kRunnerRoster) {
        expect(hero.baseSpeed, greaterThan(0), reason: '${hero.id} baseSpeed');
      }
    });

    test('every ability has positive cooldown and duration', () {
      for (final hero in kRunnerRoster) {
        expect(hero.ability.cooldownSeconds, greaterThan(0), reason: '${hero.id} cooldown');
        expect(hero.ability.durationSeconds, greaterThan(0), reason: '${hero.id} duration');
      }
    });

    test('ability duration never exceeds its own cooldown', () {
      for (final hero in kRunnerRoster) {
        expect(
          hero.ability.durationSeconds,
          lessThanOrEqualTo(hero.ability.cooldownSeconds),
          reason: '${hero.id} ability should not still be active when it comes off cooldown',
        );
      }
    });

    test('david is the first hero (default playable in Sprint 1)', () {
      expect(kRunnerRoster.first.id, 'david');
    });
  });
}
