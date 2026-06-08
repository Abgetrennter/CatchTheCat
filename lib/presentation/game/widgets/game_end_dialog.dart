import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/game_state.dart';
import '../game_notifier.dart';

class GameEndDialog extends ConsumerWidget {
  const GameEndDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final colorScheme = Theme.of(context).colorScheme;

    if (gameState.status == GameStatus.playing) return const SizedBox.shrink();

    final isWin = gameState.status == GameStatus.playerWin;

    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isWin ? '🎉' : '😿',
                style: const TextStyle(fontSize: 52),
              ),
              const SizedBox(height: 12),
              Text(
                isWin ? '你赢了！' : '你输了！',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: isWin ? colorScheme.tertiary : colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                isWin ? '猫已经无路可走' : '猫已经跑到地图边缘',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => ref.read(gameProvider.notifier).newGame(),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('再来一局'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
