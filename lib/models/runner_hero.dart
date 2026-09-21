import 'package:equatable/equatable.dart';

import 'hero_ability.dart';

class RunnerHero extends Equatable {
  const RunnerHero({
    required this.id,
    required this.displayName,
    required this.storyBasis,
    required this.ability,
    required this.baseSpeed,
  });

  final String id;
  final String displayName;
  final String storyBasis;
  final HeroAbility ability;
  final double baseSpeed;

  @override
  List<Object?> get props => [id, displayName, storyBasis, ability, baseSpeed];
}

/// V1 roster. Ability tuning (cooldown/duration) is a starting point for
/// playtesting, not final balance.
final List<RunnerHero> kRunnerRoster = [
  RunnerHero(
    id: 'david',
    displayName: 'David',
    storyBasis: '1 Samuel 17 — precision under pressure',
    ability: const HeroAbility(
      type: AbilityType.dash,
      cooldownSeconds: 6,
      durationSeconds: 0.4,
    ),
    baseSpeed: 180,
  ),
  RunnerHero(
    id: 'nehemiah',
    displayName: 'Nehemiah',
    storyBasis: 'Nehemiah 6 — rebuilding the wall under threat',
    ability: const HeroAbility(
      type: AbilityType.bridge,
      cooldownSeconds: 10,
      durationSeconds: 4,
    ),
    baseSpeed: 160,
  ),
  RunnerHero(
    id: 'rahab',
    displayName: 'Rahab',
    storyBasis: 'Joshua 2 — courage to hide and help others escape',
    ability: const HeroAbility(
      type: AbilityType.stealth,
      cooldownSeconds: 12,
      durationSeconds: 3,
    ),
    baseSpeed: 170,
  ),
  RunnerHero(
    id: 'daniel',
    displayName: 'Daniel',
    storyBasis: 'Daniel 6 — unshaken in the lion\'s den',
    ability: const HeroAbility(
      type: AbilityType.immunity,
      cooldownSeconds: 14,
      durationSeconds: 2,
    ),
    baseSpeed: 165,
  ),
  RunnerHero(
    id: 'ruth',
    displayName: 'Ruth',
    storyBasis: 'Ruth 1 — perseverance through a hard journey',
    ability: const HeroAbility(
      type: AbilityType.secondWind,
      cooldownSeconds: 9,
      durationSeconds: 2.5,
    ),
    baseSpeed: 175,
  ),
];
