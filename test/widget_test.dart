@Tags(['widget'])
library;

import 'package:flutter_test/flutter_test.dart';

import 'package:faith_runners/main.dart';

void main() {
  testWidgets('FaithRunnersApp renders the race screen', (tester) async {
    await tester.pumpWidget(const FaithRunnersApp());
    await tester.pump();

    expect(find.byType(RaceScreen), findsOneWidget);
  });
}
