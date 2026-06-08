import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/game_constants.dart';
import '../../domain/models/difficulty.dart';
import '../../domain/models/game_state.dart';
import '../../domain/models/move_record.dart';
import '../../domain/services/hex_neighbors.dart';

class GameStateModel {
  final List<List<bool>> grid;
  final int catCol;
  final int catRow;
  final GameStatus status;
  final List<MoveRecord> history;
  final Difficulty difficulty;
  final String message;
  final int? prevCatCol;
  final int? prevCatRow;
  final int? lastWallCol;
  final int? lastWallRow;

  const GameStateModel({
    required this.grid,
    required this.catCol,
    required this.catRow,
    required this.status,
    required this.history,
    required this.difficulty,
    required this.message,
    this.prevCatCol,
    this.prevCatRow,
    this.lastWallCol,
    this.lastWallRow,
  });

  GameStateModel copyWith({
    List<List<bool>>? grid,
    int? catCol,
    int? catRow,
    GameStatus? status,
    List<MoveRecord>? history,
    Difficulty? difficulty,
    String? message,
    int? prevCatCol,
    int? prevCatRow,
    int? lastWallCol,
    int? lastWallRow,
    bool clearAnimation = false,
  }) {
    return GameStateModel(
      grid: grid ?? this.grid,
      catCol: catCol ?? this.catCol,
      catRow: catRow ?? this.catRow,
      status: status ?? this.status,
      history: history ?? this.history,
      difficulty: difficulty ?? this.difficulty,
      message: message ?? this.message,
      prevCatCol: clearAnimation ? null : (prevCatCol ?? this.prevCatCol),
      prevCatRow: clearAnimation ? null : (prevCatRow ?? this.prevCatRow),
      lastWallCol: clearAnimation ? null : (lastWallCol ?? this.lastWallCol),
      lastWallRow: clearAnimation ? null : (lastWallRow ?? this.lastWallRow),
    );
  }
}

class GameNotifier extends Notifier<GameStateModel> {
  @override
  GameStateModel build() {
    return _newGame(Difficulty.hard);
  }

  void newGame([Difficulty? difficulty]) {
    state = _newGame(difficulty ?? state.difficulty);
  }

  void changeDifficulty(Difficulty difficulty) {
    state = _newGame(difficulty);
  }

  void placeWall(int col, int row) {
    if (state.status != GameStatus.playing) {
      newGame();
      return;
    }

    // 验证
    if (col < 0 ||
        col >= GameConstants.gridWidth ||
        row < 0 ||
        row >= GameConstants.gridHeight) {
      return;
    }
    if (state.grid[col][row]) return;
    if (col == state.catCol && row == state.catRow) return;

    // 放置墙壁
    final newGrid = _copyGrid(state.grid);
    newGrid[col][row] = true;

    // 检查猫是否被困
    if (_isCaught(state.catCol, state.catRow, newGrid)) {
      state = state.copyWith(
        grid: newGrid,
        status: GameStatus.playerWin,
        message: '猫已经无路可走，你赢了！',
        lastWallCol: col,
        lastWallRow: row,
        history: [
          MoveRecord(
            catCol: state.catCol,
            catRow: state.catRow,
            wallCol: col,
            wallRow: row,
          ),
          ...state.history,
        ],
      );
      return;
    }

    // AI 移动猫咪
    final direction =
        state.difficulty.solver(newGrid, state.catCol, state.catRow);
    if (direction < 0) {
      state = state.copyWith(
        grid: newGrid,
        status: GameStatus.playerWin,
        message: '猫认输，你赢了！',
        lastWallCol: col,
        lastWallRow: row,
        history: [
          MoveRecord(
            catCol: state.catCol,
            catRow: state.catRow,
            wallCol: col,
            wallRow: row,
          ),
          ...state.history,
        ],
      );
      return;
    }

    final neighbors = HexNeighbors.get(
        state.catCol, state.catRow, GameConstants.gridWidth, GameConstants.gridHeight);
    final target = neighbors[direction];
    if (target == null || newGrid[target.$1][target.$2]) {
      state = state.copyWith(
        grid: newGrid,
        status: GameStatus.playerWin,
        message: '猫认输，你赢了！',
        lastWallCol: col,
        lastWallRow: row,
      );
      return;
    }

    final newCatCol = target.$1;
    final newCatRow = target.$2;
    final oldCatCol = state.catCol;
    final oldCatRow = state.catRow;

    // 检查猫是否逃到边缘
    if (HexNeighbors.isEdge(
        newCatCol, newCatRow, GameConstants.gridWidth, GameConstants.gridHeight)) {
      state = state.copyWith(
        grid: newGrid,
        catCol: newCatCol,
        catRow: newCatRow,
        status: GameStatus.catEscaped,
        message: '猫已经跑到地图边缘了，你输了！',
        prevCatCol: oldCatCol,
        prevCatRow: oldCatRow,
        lastWallCol: col,
        lastWallRow: row,
        history: [
          MoveRecord(
            catCol: oldCatCol,
            catRow: oldCatRow,
            wallCol: col,
            wallRow: row,
          ),
          ...state.history,
        ],
      );
      return;
    }

    state = state.copyWith(
      grid: newGrid,
      catCol: newCatCol,
      catRow: newCatRow,
      message: '点击小圆点，围住小猫',
      prevCatCol: oldCatCol,
      prevCatRow: oldCatRow,
      lastWallCol: col,
      lastWallRow: row,
      history: [
        MoveRecord(
          catCol: oldCatCol,
          catRow: oldCatRow,
          wallCol: col,
          wallRow: row,
        ),
        ...state.history,
      ],
    );
  }

  void undo() {
    if (state.history.isEmpty) {
      state = state.copyWith(message: '无路可退！');
      return;
    }
    if (state.status != GameStatus.playing) {
      newGame();
      return;
    }

    final record = state.history.first;
    final newGrid = _copyGrid(state.grid);
    newGrid[record.wallCol][record.wallRow] = false;

    state = state.copyWith(
      grid: newGrid,
      catCol: record.catCol,
      catRow: record.catRow,
      history: state.history.sublist(1),
      message: '已撤销上一步',
    );
  }

  GameStateModel _newGame(Difficulty difficulty) {
    final w = GameConstants.gridWidth;
    final h = GameConstants.gridHeight;
    final grid = List.generate(w, (_) => List.generate(h, (_) => false));

    final catCol = w ~/ 2;
    final catRow = h ~/ 2;

    // 随机放置初始墙壁（Fisher-Yates 洗牌）
    final indices = <int>[];
    for (var r = 0; r < h; r++) {
      for (var c = 0; c < w; c++) {
        if (c != catCol || r != catRow) {
          indices.add(r * w + c);
        }
      }
    }

    final rng = Random();
    final wallCount = min(difficulty.initialWalls, indices.length);
    for (var i = 0; i < wallCount; i++) {
      final j = i + rng.nextInt(indices.length - i);
      final temp = indices[i];
      indices[i] = indices[j];
      indices[j] = temp;

      final wallCol = indices[i] % w;
      final wallRow = indices[i] ~/ w;
      grid[wallCol][wallRow] = true;
    }

    return GameStateModel(
      grid: grid,
      catCol: catCol,
      catRow: catRow,
      status: GameStatus.playing,
      history: const [],
      difficulty: difficulty,
      message: '点击小圆点，围住小猫',
    );
  }

  bool _isCaught(int col, int row, List<List<bool>> grid) {
    final moves = HexNeighbors.validMoves(col, row, grid);
    return moves.isEmpty;
  }

  List<List<bool>> _copyGrid(List<List<bool>> grid) {
    return [for (final col in grid) [...col]];
  }
}

final gameProvider =
    NotifierProvider<GameNotifier, GameStateModel>(GameNotifier.new);
