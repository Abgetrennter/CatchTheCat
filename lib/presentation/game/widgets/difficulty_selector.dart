import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/difficulty.dart';
import '../game_notifier.dart';

class DifficultySelector extends ConsumerWidget {
  const DifficultySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final notifier = ref.read(gameProvider.notifier);

    return SegmentedButton<Difficulty>(
      segments: [
        for (final d in Difficulty.values)
          ButtonSegment(value: d, label: Text(d.label)),
      ],
      selected: {gameState.difficulty},
      onSelectionChanged: (selected) {
        notifier.changeDifficulty(selected.first);
      },
    );
  }
}
