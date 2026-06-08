import 'dart:math';
import 'dart:ui';

class GameConstants {
  static const int gridWidth = 11;
  static const int gridHeight = 11;

  static const Color emptyColor = Color(0xFFB3D9FF);
  static const Color wallColor = Color(0xFF003366);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color catCaughtColor = Color(0xFF4CAF50);

  static const double cellPadding = 1.0;

  static double cellWidth(double radius) => radius * 2;
  static double cellHeight(double radius) => radius * sqrt(3);

  static double gridPixelWidth(int cols, double radius) =>
      (cols + 0.5) * cellWidth(radius);

  static double gridPixelHeight(int rows, double radius) =>
      rows * cellHeight(radius);

  static double maxRadius(double availableWidth, double availableHeight) {
    // 宽度需要 (cols + 0.5) 个 cellWidth，高度需要 rows 个 cellHeight
    // 留 1.5 格边距
    final fromWidth = availableWidth / ((gridWidth + 0.5) + 1.5);
    final fromHeight = availableHeight / (gridHeight * sqrt(3) + sqrt(3));
    return min(fromWidth, fromHeight) * 0.85;
  }
}
