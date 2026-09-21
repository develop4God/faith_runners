import 'package:equatable/equatable.dart';

enum AbilityType { dash, bridge, stealth, immunity, secondWind }

class HeroAbility extends Equatable {
  const HeroAbility({
    required this.type,
    required this.cooldownSeconds,
    required this.durationSeconds,
  });

  final AbilityType type;
  final double cooldownSeconds;
  final double durationSeconds;

  @override
  List<Object?> get props => [type, cooldownSeconds, durationSeconds];
}
