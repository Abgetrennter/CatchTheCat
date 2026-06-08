import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../game_notifier.dart';

class WallCountSlider extends ConsumerWidget {
  const WallCountSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            '障碍: ${gameState.initialWalls}',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(
            child: Slider(
              value: gameState.initialWalls.toDouble(),
              min: 0,
              max: 20,
              divisions: 20,
              label: '${gameState.initialWalls}',
              onChanged: (value) {
                ref.read(gameProvider.notifier).setInitialWalls(value.round());
              },
            ),
          ),
        ],
      ),
    );
  }
}
