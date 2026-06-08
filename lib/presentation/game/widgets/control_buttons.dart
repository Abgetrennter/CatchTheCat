import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/game_state.dart';
import '../game_notifier.dart';

class ControlButtons extends ConsumerWidget {
  const ControlButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(gameProvider.notifier);
    final gameState = ref.watch(gameProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FilledButton.tonal(
            onPressed: gameState.status == GameStatus.playing
                ? () => notifier.undo()
                : null,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.undo, size: 18),
                SizedBox(width: 4),
                Text('悔棋'),
              ],
            ),
          ),
          FilledButton(
            onPressed: () => notifier.newGame(),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh, size: 18),
                SizedBox(width: 4),
                Text('重开'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
