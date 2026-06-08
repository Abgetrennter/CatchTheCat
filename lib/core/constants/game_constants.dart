import 'dart:math';

class GameConstants {
  static const int gridWidth = 11;
  static const int gridHeight = 11;

  static double cellWidth(double radius) => radius * 2;
  static double cellHeight(double radius) => radius * sqrt(3);

  static double gridPixelWidth(int cols, double radius) =>
      (cols + 0.5) * cellWidth(radius);

  static double gridPixelHeight(int rows, double radius) =>
      rows * cellHeight(radius);

  static double maxRadius(double availableWidth, double availableHeight) {
    final fromWidth = availableWidth / ((gridWidth + 0.5) + 1.5);
    final fromHeight = availableHeight / (gridHeight * sqrt(3) + sqrt(3));
    return min(fromWidth, fromHeight) * 0.85;
  }
}
