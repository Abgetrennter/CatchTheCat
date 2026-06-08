import 'package:flutter/material.dart';
import 'widgets/hex_grid.dart';
import 'widgets/game_status_bar.dart';
import 'widgets/control_buttons.dart';
import 'widgets/difficulty_selector.dart';
import 'widgets/game_end_dialog.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('围住小猫'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: DifficultySelector(),
            ),
            const Expanded(
              child: Stack(
                children: [
                  HexGrid(),
                  GameEndDialog(),
                ],
              ),
            ),
            const GameStatusBar(),
            const SizedBox(height: 4),
            const ControlButtons(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
