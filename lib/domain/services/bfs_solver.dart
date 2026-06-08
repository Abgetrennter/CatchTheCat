import 'hex_neighbors.dart';

/// BFS 计算所有非墙格子到边缘的最短距离
class BfsSolver {
  final int width;
  final int height;
  final List<List<bool>> grid;
  late final List<List<double>> _distance;

  BfsSolver(this.grid)
      : width = grid.length,
        height = grid.isNotEmpty ? grid[0].length : 0 {
    _distance = [
      for (var c = 0; c < width; c++)
        [for (var r = 0; r < height; r++) double.infinity]
    ];
    _calcAllDistances();
  }

  double distance(int col, int row) => _distance[col][row];

  bool isEdge(int col, int row) =>
      col <= 0 || col >= width - 1 || row <= 0 || row >= height - 1;

  /// 计算从指定格子出发的最优移动方向（距离最短）
  /// 返回方向索引 0-5，-1 表示无路可走
  int bestDirection(int col, int row) {
    final neighbors = HexNeighbors.get(col, row, width, height);
    final currentDist = _distance[col][row];

    int bestDir = -1;
    double bestDist = currentDist;

    for (var d = 0; d < neighbors.length; d++) {
      final n = neighbors[d];
      if (n == null || grid[n.$1][n.$2]) continue;
      final nd = _distance[n.$1][n.$2];
      if (nd < bestDist) {
        bestDist = nd;
        bestDir = d;
      }
    }
    return bestDir;
  }

  /// 计算从指定格子出发的最优移动方向（距离最短 + 逃生路线最多）
  int bestDirectionWithRoutes(int col, int row) {
    final neighbors = HexNeighbors.get(col, row, width, height);
    final currentDist = _distance[col][row];

    // 先收集所有距离更短的邻居方向
    final candidates = <int>[];
    double minDist = double.infinity;
    for (var d = 0; d < neighbors.length; d++) {
      final n = neighbors[d];
      if (n == null || grid[n.$1][n.$2]) continue;
      final nd = _distance[n.$1][n.$2];
      if (nd < currentDist) {
        if (nd < minDist) {
          minDist = nd;
          candidates.clear();
          candidates.add(d);
        } else if (nd == minDist) {
          candidates.add(d);
        }
      }
    }

    if (candidates.isEmpty) return -1;
    if (candidates.length == 1) return candidates.first;

    // 多个候选方向，选择 routesCount 最大的
    int bestDir = candidates.first;
    int maxRoutes = 0;
    for (final d in candidates) {
      final n = neighbors[d]!;
      final routes = _routesCount(n.$1, n.$2);
      if (routes > maxRoutes) {
        maxRoutes = routes;
        bestDir = d;
      }
    }
    return bestDir;
  }

  /// 递归计算从 (col, row) 到边缘的路线数量
  int _routesCount(int col, int row) {
    if (isEdge(col, row)) return 1;
    if (grid[col][row]) return 0;

    final currentDist = _distance[col][row];
    var count = 0;
    final neighbors = HexNeighbors.get(col, row, width, height);
    for (final n in neighbors) {
      if (n == null || grid[n.$1][n.$2]) continue;
      if (_distance[n.$1][n.$2] < currentDist) {
        count += _routesCount(n.$1, n.$2);
      }
    }
    return count;
  }

  void _calcAllDistances() {
    final queue = <(int, int)>[];

    // 初始化：所有边缘非墙格子距离为 0
    for (var c = 0; c < width; c++) {
      for (var r = 0; r < height; r++) {
        if (isEdge(c, r) && !grid[c][r]) {
          _distance[c][r] = 0;
          queue.add((c, r));
        }
      }
    }

    // BFS 扩展
    final visited = <String>{};
    for (final p in queue) {
      visited.add('${p.$1},${p.$2}');
    }

    var head = 0;
    while (head < queue.length) {
      final (c, r) = queue[head++];
      final currentDist = _distance[c][r];
      final neighbors = HexNeighbors.get(c, r, width, height);

      for (final n in neighbors) {
        if (n == null) continue;
        final (nc, nr) = n;
        if (grid[nc][nr] || isEdge(nc, nr)) continue;

        final newDist = currentDist + 1;
        if (newDist < _distance[nc][nr]) {
          _distance[nc][nr] = newDist;
          final key = '$nc,$nr';
          if (!visited.contains(key)) {
            visited.add(key);
            queue.add((nc, nr));
          }
        }
      }
    }
  }
}
