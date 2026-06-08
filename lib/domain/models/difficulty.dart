import '../services/cat_solver.dart';

enum Difficulty {
  easy(
    label: '简单',
    initialWalls: 10,
    solver: randomSolver,
  ),
  medium(
    label: '中等',
    initialWalls: 6,
    solver: defaultSolver,
  ),
  hard(
    label: '困难',
    initialWalls: 6,
    solver: nearestSolver,
  ),
  hell(
    label: '地狱',
    initialWalls: 4,
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
