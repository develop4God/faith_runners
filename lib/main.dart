import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';

import 'game/faith_runners_game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const FaithRunnersApp());
}

class FaithRunnersApp extends StatelessWidget {
  const FaithRunnersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FaithRunners',
      debugShowCheckedModeBanner: false,
      home: const RaceScreen(),
    );
  }
}

class RaceScreen extends StatefulWidget {
  const RaceScreen({super.key});

  @override
  State<RaceScreen> createState() => _RaceScreenState();
}

class _RaceScreenState extends State<RaceScreen> {
  final FaithRunnersGame _game = FaithRunnersGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(
            game: _game,
            overlayBuilderMap: {
              'win': (context, game) => _ResultOverlay(
                    message: 'You made it! 🎉',
                    subtitle: 'Flight to Egypt — Matthew 2',
                    onRestart: () => setState(_game.restart),
                  ),
              'lose': (context, game) => _ResultOverlay(
                    message: 'Spotted! Try again.',
                    subtitle: 'Flight to Egypt — Matthew 2',
                    onRestart: () => setState(_game.restart),
                  ),
            },
          ),
          Positioned(
            top: 16,
            right: 16,
            child: _TimerBadge(game: _game),
          ),
          Positioned(
            right: 32,
            bottom: 32,
            child: _AbilityButton(game: _game),
          ),
        ],
      ),
    );
  }
}

class _TimerBadge extends StatelessWidget {
  const _TimerBadge({required this.game});

  final FaithRunnersGame game;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<void>(
      stream: Stream.periodic(const Duration(milliseconds: 100)),
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            game.timeRemaining.ceil().toString(),
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}

class _AbilityButton extends StatelessWidget {
  const _AbilityButton({required this.game});

  final FaithRunnersGame game;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<void>(
      stream: Stream.periodic(const Duration(milliseconds: 100)),
      builder: (context, _) {
        if (!game.isReady) return const SizedBox(width: 64, height: 64);
        final ready = game.player.abilityReady;
        return GestureDetector(
          onTap: () => game.player.tryActivateAbility(),
          child: SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 64,
                  height: 64,
                  child: CircularProgressIndicator(
                    value: ready ? 1 : 1 - game.player.abilityCooldownFraction,
                    strokeWidth: 4,
                    backgroundColor: Colors.black26,
                    valueColor: AlwaysStoppedAnimation(
                      ready ? const Color(0xFFE8B84B) : Colors.white38,
                    ),
                  ),
                ),
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (ready ? const Color(0xFFE8B84B) : Colors.grey).withValues(alpha: 0.85),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.bolt, color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ResultOverlay extends StatelessWidget {
  const _ResultOverlay({
    required this.message,
    required this.subtitle,
    required this.onRestart,
  });

  final String message;
  final String subtitle;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.6),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: onRestart, child: const Text('Run again')),
        ],
      ),
    );
  }
}
