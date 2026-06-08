import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/game_state.dart';
import '../game_notifier.dart';

class GameEndDialog extends ConsumerWidget {
  const GameEndDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);

    if (gameState.status == GameStatus.playing) return const SizedBox.shrink();

    final isWin = gameState.status == GameStatus.playerWin;

    return Center(
      child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isWin ? '🎉' : '😿',
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 12),
              Text(
                isWin ? '你赢了！' : '你输了！',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: isWin ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                isWin ? '猫已经无路可走' : '猫已经跑到地图边缘',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  ref.read(gameProvider.notifier).newGame();
                },
                child: const Text('再来一局'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
