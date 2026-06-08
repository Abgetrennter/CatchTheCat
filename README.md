# 🐱 CatchTheCat / 围住小猫

A hex grid puzzle game built with Flutter. Surround the cat before it escapes!

基于 Flutter 的六角格策略小游戏，点击格子放置障碍，围住小猫不让它跑到地图边缘。

## Screenshots

*(Coming soon)*

## Features

- 9x9 hexagonal grid with offset coordinate system
- 4 AI difficulty levels (Easy / Medium / Hard / Hell) powered by BFS pathfinding
- Adjustable initial obstacle count (0–20)
- Undo & reset support
- Morandi-inspired Material You 3 theme
- Smooth cat movement & wall placement animations
- Cross-platform: Android, iOS, Web, Windows, macOS, Linux

## How to Play

1. Click/tap any empty circle to place a wall
2. The cat moves one step toward the nearest edge
3. **You win** if the cat has no valid moves (completely surrounded)
4. **You lose** if the cat reaches any edge cell

## Getting Started

```bash
# Install dependencies
flutter pub get

# Run on connected device
flutter run

# Build release APK
flutter build apk

# Build Windows
flutter build windows

# Build Web
flutter build web
```

## Tech Stack

| Layer | Tech |
|-------|------|
| Framework | Flutter 3.x |
| Language | Dart |
| State Management | Riverpod 2.x |
| Rendering | CustomPainter |
| AI Solver | BFS + routesCount algorithm |
| Theme | Material Design 3 (Morandi palette) |

## Project Structure

```
lib/
  main.dart
  app.dart
  core/
    constants/game_constants.dart
    theme/app_theme.dart
  domain/
    models/          # GameState, Difficulty, MoveRecord
    services/        # HexNeighbors, BfsSolver, CatSolvers
  presentation/
    game/
      game_screen.dart
      game_notifier.dart
      widgets/       # HexGrid, StatusBar, Controls, Dialog, Slider
```

## AI Solvers

| Difficulty | Algorithm | Behavior |
|-----------|-----------|----------|
| Easy | Random | Picks a random valid direction |
| Medium | Default | Takes the first available direction |
| Hard | BFS Nearest | Finds shortest path to edge |
| Hell | BFS + Routes | Shortest path + maximum escape routes |

## License

MIT
