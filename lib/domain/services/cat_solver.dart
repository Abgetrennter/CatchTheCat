import 'dart:math';
import 'hex_neighbors.dart';
import 'bfs_solver.dart';

/// Cat AI 求解器签名
/// grid[col][row] = true 表示墙，(catCol, catRow) 是猫的位置
/// 返回方向索引 0-5，-1 表示无路可走
typedef CatSolverFn = int Function(
    List<List<bool>> grid, int catCol, int catRow);

/// 猫认输，始终不移动
int idiotSolver(List<List<bool>> grid, int catCol, int catRow) {
  return -1;
}

/// 第一个可用方向
int defaultSolver(List<List<bool>> grid, int catCol, int catRow) {
  final moves = HexNeighbors.validMoves(catCol, catRow, grid);
  if (moves.isEmpty) return -1;
  return moves.first.$1;
}

/// 随机方向
int randomSolver(List<List<bool>> grid, int catCol, int catRow) {
  final moves = HexNeighbors.validMoves(catCol, catRow, grid);
  if (moves.isEmpty) return -1;
  return moves[Random().nextInt(moves.length)].$1;
}

/// BFS 最短路径到边缘
int nearestSolver(List<List<bool>> grid, int catCol, int catRow) {
  final bfs = BfsSolver(grid);
  return bfs.bestDirection(catCol, catRow);
}

/// BFS 最短路径 + 最多逃生路线
int nearestRoutesSolver(List<List<bool>> grid, int catCol, int catRow) {
  final bfs = BfsSolver(grid);
  return bfs.bestDirectionWithRoutes(catCol, catRow);
}
