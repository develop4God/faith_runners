import 'package:equatable/equatable.dart';

enum HazardType { searchParty, closingWalls, risingWater }

class RaceMap extends Equatable {
  const RaceMap({
    required this.id,
    required this.displayName,
    required this.storyBasis,
    required this.hazard,
  });

  final String id;
  final String displayName;
  final String storyBasis;
  final HazardType hazard;

  @override
  List<Object?> get props => [id, displayName, storyBasis, hazard];
}

final List<RaceMap> kLaunchMaps = [
  const RaceMap(
    id: 'flight_to_egypt',
    displayName: 'Flight to Egypt',
    storyBasis: 'Matthew 2 — the Holy Family\'s escape',
    hazard: HazardType.searchParty,
  ),
  const RaceMap(
    id: 'jerichos_walls',
    displayName: "Jericho's Walls",
    storyBasis: 'Joshua 6 — the march around Jericho',
    hazard: HazardType.closingWalls,
  ),
  const RaceMap(
    id: 'red_sea_crossing',
    displayName: 'Red Sea Crossing',
    storyBasis: 'Exodus 14 — Israel crosses on dry ground',
    hazard: HazardType.risingWater,
  ),
];
