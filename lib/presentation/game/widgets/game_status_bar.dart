import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/game_state.dart';
import '../game_notifier.dart';

class GameStatusBar extends ConsumerWidget {
  const GameStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        gameState.message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: gameState.status == GameStatus.playerWin
                  ? Colors.green
                  : gameState.status == GameStatus.catEscaped
                      ? Colors.red
                      : null,
            ),
      ),
    );
  }
}
