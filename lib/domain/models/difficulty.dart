import '../services/cat_solver.dart';

enum Difficulty {
  easy(
    label: '简单',
    initialWalls: 12,
    solver: randomSolver,
  ),
  medium(
    label: '中等',
    initialWalls: 8,
    solver: defaultSolver,
  ),
  hard(
    label: '困难',
    initialWalls: 8,
    solver: nearestSolver,
  ),
  hell(
    label: '地狱',
    initialWalls: 6,
    solver: nearestRoutesSolver,
  );

  final String label;
  final int initialWalls;
  final CatSolverFn solver;

  const Difficulty({
    required this.label,
    required this.initialWalls,
    required this.solver,
  });
}
