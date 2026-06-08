import 'package:flutter/material.dart';

/// 莫兰迪色系：低饱和、灰调、高级感
class MorandiColors {
  // 主色 - 灰绿
  static const primary = Color(0xFF7A9E7E);
  static const onPrimary = Color(0xFF1A2E1C);

  // 主色容器 - 浅灰绿（空格子）
  static const primaryContainer = Color(0xFFD4DDD4);

  // 次要 - 灰粉/暖灰
  static const secondary = Color(0xFFB5A89A);
  static const secondaryContainer = Color(0xFFE8DFD5);

  // 第三色 - 灰蓝（胜利）
  static const tertiary = Color(0xFF8FA3AE);
  static const onTertiary = Color(0xFF1C2A33);

  // 错误色 - 莫兰迪红
  static const error = Color(0xFFC4918A);
  static const onError = Color(0xFF2E1A17);

  // 表面
  static const surface = Color(0xFFF5F2EE);
  static const onSurface = Color(0xFF3C3A37);
  static const onSurfaceVariant = Color(0xFF6B6862);
  static const outline = Color(0xFFC2BEB8);
  static const outlineVariant = Color(0xFFC8CEC8);
  static const shadow = Color(0xFF5A5854);

  // 卡片
  static const surfaceContainerHigh = Color(0xFFEAE7E2);
}

class AppTheme {
  static ThemeData light(BuildContext context) {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: MorandiColors.primary,
      onPrimary: MorandiColors.onPrimary,
      primaryContainer: MorandiColors.primaryContainer,
      onPrimaryContainer: MorandiColors.onPrimary,
      secondary: MorandiColors.secondary,
      onSecondary: MorandiColors.onPrimary,
      secondaryContainer: MorandiColors.secondaryContainer,
      onSecondaryContainer: MorandiColors.onPrimary,
      tertiary: MorandiColors.tertiary,
      onTertiary: MorandiColors.onTertiary,
      tertiaryContainer: const Color(0xFFD3E0E6),
      onTertiaryContainer: MorandiColors.onTertiary,
      error: MorandiColors.error,
      onError: MorandiColors.onError,
      errorContainer: const Color(0xFFEEDAD6),
      onErrorContainer: MorandiColors.onError,
      surface: MorandiColors.surface,
      onSurface: MorandiColors.onSurface,
      surfaceContainerHighest: MorandiColors.surfaceContainerHigh,
      surfaceContainerHigh: MorandiColors.surfaceContainerHigh,
      surfaceContainerLow: const Color(0xFFF7F4F0),
      surfaceDim: const Color(0xFFE8E5E0),
      surfaceBright: MorandiColors.surface,
      onSurfaceVariant: MorandiColors.onSurfaceVariant,
      outline: MorandiColors.outline,
      outlineVariant: MorandiColors.outlineVariant,
      shadow: MorandiColors.shadow,
      inverseSurface: const Color(0xFF3C3A37),
      onInverseSurface: const Color(0xFFF5F2EE),
      inversePrimary: const Color(0xFFA8C8AC),
      scrim: MorandiColors.shadow,
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.resolveWith((states) {
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            );
          }),
          visualDensity: VisualDensity.compact,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: colorScheme.surfaceContainerHigh,
      ),
    );
  }
}
