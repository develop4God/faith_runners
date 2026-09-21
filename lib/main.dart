import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import 'game/faith_runners_game.dart';

void main() {
  runApp(const FaithRunnersApp());
}

class FaithRunnersApp extends StatelessWidget {
  const FaithRunnersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FaithRunners',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget(game: FaithRunnersGame()),
      ),
    );
  }
}
