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
          FilledButton.tonalIcon(
            onPressed: gameState.status == GameStatus.playing
                ? () => notifier.undo()
                : null,
            icon: const Icon(Icons.undo_rounded),
            label: const Text('悔棋'),
          ),
          FilledButton.icon(
            onPressed: () => notifier.newGame(),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('重开'),
          ),
        ],
      ),
    );
  }
}
