import 'dart:math';

class GameConstants {
  static const int gridWidth = 9;
  static const int gridHeight = 9;

  static double cellWidth(double radius) => radius * 2;
  static double cellHeight(double radius) => radius * sqrt(3);

  static double gridPixelWidth(int cols, double radius) =>
      (cols + 0.5) * cellWidth(radius);

  static double gridPixelHeight(int rows, double radius) =>
      rows * cellHeight(radius);

  static double maxRadius(double availableWidth, double availableHeight) {
    // 网格实际像素尺寸
    // 宽: (cols + 0.5) * 2r
    // 高: rows * sqrt(3) * r
    // 反推 radius，留 10% 边距
    final fromWidth = availableWidth * 0.9 / ((gridWidth + 0.5) * 2);
    final fromHeight = availableHeight * 0.9 / (gridHeight * sqrt(3));
    return min(fromWidth, fromHeight);
  }
}
