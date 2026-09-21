# FaithRunners

A fast, skill-based arcade race game featuring biblical heroes. No combat,
no quizzes — each hero's ability comes from their real story, and the win
condition is always speed, precision, or courage under pressure, never
defeating another player.

## Concept

- **Genre**: competitive arcade race/pursuit, 4-player free-for-all, 60-90s matches.
- **Heroes** (`lib/models/runner_hero.dart`): David, Nehemiah, Rahab, Daniel, Ruth —
  each ability is a movement/utility power grounded in their story, not a weapon.
- **Maps** (`lib/models/race_map.dart`): Flight to Egypt, Jericho's Walls,
  Red Sea Crossing — each hazard is drawn from the actual tension in the story.
- Post-match, an optional one-line story caption ties the hero's ability back
  to scripture — gameplay never stops to teach.

## Status

This is a V1 scaffold: game logic (`lib/`) and models are hand-written, but
platform folders (`android/`, `ios/`, `web/`, etc.) have **not** been
generated yet, since this was scaffolded in an environment without a
Flutter SDK installed.

### To get a running build

```bash
flutter create .        # generates android/, ios/, and other platform folders
                         # without touching the existing lib/ or pubspec.yaml
flutter pub get
flutter run
```

## Structure

```
lib/
  main.dart                     # app entry, wires up GameWidget
  game/
    faith_runners_game.dart     # FlameGame shell, joystick + player
    runner_component.dart       # placeholder runner (circle sprite for now)
  models/
    runner_hero.dart            # hero roster + stats
    hero_ability.dart           # ability type/cooldown/duration
    race_map.dart               # launch map roster + hazard type
assets/
  images/heroes/                # AI-generated hero sprites go here
  images/maps/                  # AI-generated tilesets/hazards go here
  images/ui/                    # HUD/menu art
  audio/
```

Art generation prompts (JSON, per-hero/per-map, style-guide locked) live in
the `devocional_nuevo` repo under `game_assets_prompts/` during early
concepting — will move here once the roster art is finalized.
