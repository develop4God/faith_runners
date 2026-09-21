@Tags(['unit'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:faith_runners/models/race_map.dart';

void main() {
  group('kLaunchMaps', () {
    test('has exactly the 3 launch maps', () {
      expect(kLaunchMaps.length, 3);
    });

    test('every map has a unique id', () {
      final ids = kLaunchMaps.map((m) => m.id).toSet();
      expect(ids.length, kLaunchMaps.length);
    });

    test('flight_to_egypt is the Sprint 1 map and uses the search party hazard', () {
      final map = kLaunchMaps.firstWhere((m) => m.id == 'flight_to_egypt');
      expect(map.hazard, HazardType.searchParty);
    });
  });
}
