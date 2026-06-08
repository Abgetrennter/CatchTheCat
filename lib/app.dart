import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/game/game_screen.dart';

class CatchTheCatApp extends StatelessWidget {
  const CatchTheCatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '围住小猫',
      theme: AppTheme.light(context),
      home: const GameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
