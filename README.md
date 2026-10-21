# RetroPlay Arcade — Modular Flutter Starter

Retro-style, offline-first casual game collection for Android and iOS.

## Games included
- Snake
- Tic-Tac-Toe
- Dots & Boxes
- Number Merge (2048-style)
- Memory Match
- Minesweeper
- Pong
- Whack-a-Mole
- Sliding Puzzle
- Hangman
- Reaction Tap

The four initial games are implemented in separate feature folders. Additional games have their own folders and playable starter implementations. All core gameplay is local.

## Setup
```bash
flutter create retroplay_arcade
cd retroplay_arcade
flutter pub add shared_preferences
```
Copy the `lib/` folder from this archive into the generated project, replacing the generated `lib/` folder.

Then:
```bash
flutter pub get
flutter run
flutter test
```

## Build
```bash
flutter build apk --release
flutter build ios --release
```
iOS builds require macOS and Xcode.

## Architecture
Each game is isolated under `lib/features/<game_name>/` with:
- `domain/`: rules and state models
- `presentation/`: screen widgets
- `widgets/`: game-specific reusable pieces where needed

Shared colors and storage live in `lib/core/`. The app uses Flutter animations (implicit and explicit) for card entrance, board changes, game results, matching cards, tile changes, mine reveal and reaction feedback.

## Offline behavior
- No API calls or account needed.
- Assets and rules are bundled in the app.
- Best scores and settings use SharedPreferences.
- Local data can be erased if the app is uninstalled or its data is cleared.

## QA notes
This is a starter scaffold, not a verified store release. Run `flutter analyze`, `flutter test`, and manual play tests on Android and iOS before release.
