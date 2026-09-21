@Tags(['unit'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:faith_runners/game/search_party_hazard.dart';

void main() {
  group('SearchPartyHazard', () {
    test('starts at the given y and left edge of the arena', () {
      final hazard = SearchPartyHazard(arenaWidth: 400, bandHeight: 70, y: 120);
      expect(hazard.position.y, 120);
      expect(hazard.position.x, 0);
      expect(hazard.size.y, 70);
    });

    test('sweeps right, then reverses at the arena bound', () {
      final hazard = SearchPartyHazard(arenaWidth: 400, bandHeight: 70, y: 0);
      final startX = hazard.position.x;

      hazard.update(1 / 60);
      expect(hazard.position.x, greaterThan(startX), reason: 'should move right initially');

      // Advance far enough to guarantee it hits the right bound and bounces.
      for (var i = 0; i < 600; i++) {
        hazard.update(1 / 60);
      }
      final xAfterManySteps = hazard.position.x;

      // If it never reversed, it would be pinned at (or past) the right
      // bound; reversal means it comes back below the max reachable edge.
      final maxX = 400 - hazard.size.x;
      expect(xAfterManySteps, lessThanOrEqualTo(maxX));
    });

    test('never moves outside the arena bounds', () {
      final hazard = SearchPartyHazard(arenaWidth: 400, bandHeight: 70, y: 0);
      for (var i = 0; i < 2000; i++) {
        hazard.update(1 / 60);
        expect(hazard.position.x, greaterThanOrEqualTo(0));
        expect(hazard.position.x, lessThanOrEqualTo(400 - hazard.size.x));
      }
    });
  });
}
