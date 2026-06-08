import 'dart:math';

class HexNeighbors {
  static const int directionCount = 6;

  /// 返回 (col, row) 的 6 个邻居坐标，方向顺序:
  /// 0: left, 1: topLeft, 2: topRight, 3: right, 4: bottomRight, 5: bottomLeft
  /// 越界时对应位置为 null
  static List<(int, int)?> get(
      int col, int row, int gridWidth, int gridHeight) {
    final left = (col - 1, row);
    final right = (col + 1, row);

    (int, int) topLeft;
    (int, int) topRight;
    (int, int) bottomLeft;
    (int, int) bottomRight;

    if (row % 2 == 0) {
      topLeft = (col - 1, row - 1);
      topRight = (col, row - 1);
      bottomLeft = (col - 1, row + 1);
      bottomRight = (col, row + 1);
    } else {
      topLeft = (col, row - 1);
      topRight = (col + 1, row - 1);
      bottomLeft = (col, row + 1);
      bottomRight = (col + 1, row + 1);
    }

    return [
      _clamp(left, gridWidth, gridHeight),
      _clamp(topLeft, gridWidth, gridHeight),
      _clamp(topRight, gridWidth, gridHeight),
      _clamp(right, gridWidth, gridHeight),
      _clamp(bottomRight, gridWidth, gridHeight),
      _clamp(bottomLeft, gridWidth, gridHeight),
    ];
  }

  /// 获取所有有效邻居（非墙、非越界）
  static List<(int direction, int col, int row)> validMoves(
    int col,
    int row,
    List<List<bool>> grid,
  ) {
    final w = grid.length;
    final h = grid.isNotEmpty ? grid[0].length : 0;
    final neighbors = get(col, row, w, h);
    final result = <(int, int, int)>[];
    for (var d = 0; d < neighbors.length; d++) {
      final n = neighbors[d];
      if (n != null && !grid[n.$1][n.$2]) {
        result.add((d, n.$1, n.$2));
      }
    }
    return result;
  }

  /// 是否在网格边缘
  static bool isEdge(int col, int row, int gridWidth, int gridHeight) {
    return col <= 0 ||
        col >= gridWidth - 1 ||
        row <= 0 ||
        row >= gridHeight - 1;
  }

  /// 将格子坐标转换为像素中心坐标
  static Point<double> cellToPixel(int col, int row, double radius) {
    final cw = radius * 2;
    final ch = radius * sqrt(3);
    return Point(
      radius + col * cw + (row.isOdd ? radius : 0),
      radius + row * ch,
    );
  }

  /// 根据像素坐标找到最近的格子
  static (int col, int row)? pixelToCell(
    double px,
    double py,
    double radius,
    int gridWidth,
    int gridHeight,
  ) {
    int? bestCol;
    int? bestRow;
    double bestDist = double.infinity;

    for (var r = 0; r < gridHeight; r++) {
      for (var c = 0; c < gridWidth; c++) {
        final center = cellToPixel(c, r, radius);
        final dist = (px - center.x).abs() + (py - center.y).abs();
        if (dist < bestDist && dist < radius * 1.5) {
          bestDist = dist;
          bestCol = c;
          bestRow = r;
        }
      }
    }

    if (bestCol != null && bestRow != null) {
      return (bestCol, bestRow);
    }
    return null;
  }

  static (int, int)? _clamp((int, int) pos, int w, int h) {
    if (pos.$1 >= 0 && pos.$1 < w && pos.$2 >= 0 && pos.$2 < h) {
      return pos;
    }
    return null;
  }
}
