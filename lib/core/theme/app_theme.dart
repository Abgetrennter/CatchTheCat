import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        colorSchemeSeed: const Color(0xFF003366),
        brightness: Brightness.light,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
      );
}
