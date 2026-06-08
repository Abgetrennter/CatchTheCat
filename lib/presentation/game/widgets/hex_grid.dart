import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/game_constants.dart';
import '../../../domain/models/game_state.dart';
import '../../../domain/services/hex_neighbors.dart';
import '../game_notifier.dart';

class HexGrid extends ConsumerStatefulWidget {
  const HexGrid({super.key});

  @override
  ConsumerState<HexGrid> createState() => _HexGridState();
}

class _HexGridState extends ConsumerState<HexGrid>
    with TickerProviderStateMixin {
  late final AnimationController _catAnimCtrl;
  late final AnimationController _wallAnimCtrl;
  late Animation<double> _catAnim;
  late Animation<double> _wallAnim;

  int? _prevCatCol;
  int? _prevCatRow;
  int? _lastWallCol;
  int? _lastWallRow;
  bool _catMoved = false;
  bool _wallPlaced = false;

  @override
  void initState() {
    super.initState();

    _catAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _catAnim = CurvedAnimation(parent: _catAnimCtrl, curve: Curves.easeInOut);

    _wallAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _wallAnim = CurvedAnimation(parent: _wallAnimCtrl, curve: Curves.easeOutBack);

    _catAnimCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _catMoved = false;
      }
    });
    _wallAnimCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _wallPlaced = false;
      }
    });
  }

  @override
  void dispose() {
    _catAnimCtrl.dispose();
    _wallAnimCtrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HexGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    final gs = ref.read(gameProvider);

    // 检测猫是否移动了
    if (gs.prevCatCol != null && gs.prevCatRow != null && !_catMoved) {
      _prevCatCol = gs.prevCatCol;
      _prevCatRow = gs.prevCatRow;
      _catMoved = true;
      _catAnimCtrl.forward(from: 0);
    }

    // 检测新墙壁
    if (gs.lastWallCol != null && gs.lastWallRow != null && !_wallPlaced) {
      _lastWallCol = gs.lastWallCol;
      _lastWallRow = gs.lastWallRow;
      _wallPlaced = true;
      _wallAnimCtrl.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: Listenable.merge([_catAnimCtrl, _wallAnimCtrl]),
      builder: (context, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final radius = GameConstants.maxRadius(
              constraints.maxWidth,
              constraints.maxHeight,
            );

            return GestureDetector(
              onTapUp: (details) {
                final renderBox = context.findRenderObject() as RenderBox;
                final localPos =
                    renderBox.globalToLocal(details.globalPosition);

                final gridWidth =
                    GameConstants.gridWidth * radius * 2 + radius;
                final gridHeight =
                    GameConstants.gridHeight * radius * sqrt(3);
                final offsetX = (constraints.maxWidth - gridWidth) / 2;
                final offsetY = (constraints.maxHeight - gridHeight) / 2;

                final cell = HexNeighbors.pixelToCell(
                  localPos.dx - offsetX,
                  localPos.dy - offsetY,
                  radius,
                  GameConstants.gridWidth,
                  GameConstants.gridHeight,
                );

                if (cell != null) {
                  ref.read(gameProvider.notifier).placeWall(cell.$1, cell.$2);
                }
              },
              child: CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: _HexGridPainter(
                  grid: gameState.grid,
                  catCol: gameState.catCol,
                  catRow: gameState.catRow,
                  radius: radius,
                  status: gameState.status,
                  colorScheme: colorScheme,
                  catProgress: _catAnim.value,
                  prevCatCol: _prevCatCol,
                  prevCatRow: _prevCatRow,
                  wallProgress: _wallAnim.value,
                  lastWallCol: _lastWallCol,
                  lastWallRow: _lastWallRow,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _HexGridPainter extends CustomPainter {
  final List<List<bool>> grid;
  final int catCol;
  final int catRow;
  final double radius;
  final GameStatus status;
  final ColorScheme colorScheme;

  // 动画参数
  final double catProgress;
  final int? prevCatCol;
  final int? prevCatRow;
  final double wallProgress;
  final int? lastWallCol;
  final int? lastWallRow;

  _HexGridPainter({
    required this.grid,
    required this.catCol,
    required this.catRow,
    required this.radius,
    required this.status,
    required this.colorScheme,
    this.catProgress = 1.0,
    this.prevCatCol,
    this.prevCatRow,
    this.wallProgress = 1.0,
    this.lastWallCol,
    this.lastWallRow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = GameConstants.gridWidth;
    final h = GameConstants.gridHeight;

    final gridWidth = w * radius * 2 + radius;
    final gridHeight = h * radius * sqrt(3);
    final offsetX = (size.width - gridWidth) / 2;
    final offsetY = (size.height - gridHeight) / 2;

    canvas.save();
    canvas.translate(offsetX, offsetY);

    final emptyFill = Paint()..color = colorScheme.primaryContainer;
    final emptyStroke = Paint()
      ..color = colorScheme.outlineVariant
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final wallFill = Paint()..color = colorScheme.primary;
    final wallShadow = Paint()
      ..color = colorScheme.shadow.withValues(alpha: 0.12);
    final caughtFill = Paint()..color = colorScheme.tertiary;

    for (var row = 0; row < h; row++) {
      for (var col = 0; col < w; col++) {
        final center = HexNeighbors.cellToPixel(col, row, radius);
        final isWall = grid[col][row];
        final isCat = col == catCol && row == catRow;
        final r = radius * 0.82;
        final offset = Offset(center.x, center.y);

        // 正在动画中的墙壁：缩放效果
        final isAnimatingWall =
            col == lastWallCol && row == lastWallRow && wallProgress < 1.0;

        if (isCat && status == GameStatus.playerWin) {
          canvas.drawCircle(offset, r, caughtFill);
        } else if (isWall) {
          if (isAnimatingWall) {
            final scale = wallProgress;
            canvas.drawCircle(
                Offset(offset.dx, offset.dy + 1.5 * scale),
                r * scale,
                wallShadow);
            canvas.drawCircle(offset, r * scale, wallFill);
          } else {
            canvas.drawCircle(
                Offset(offset.dx, offset.dy + 1.5), r, wallShadow);
            canvas.drawCircle(offset, r, wallFill);
          }
        } else {
          canvas.drawCircle(offset, r, emptyFill);
          canvas.drawCircle(offset, r, emptyStroke);
        }
      }
    }

    // 猫咪 Emoji — 动画插值位置
    Offset catOffset;
    if (prevCatCol != null &&
        prevCatRow != null &&
        catProgress < 1.0) {
      final from = HexNeighbors.cellToPixel(prevCatCol!, prevCatRow!, radius);
      final to = HexNeighbors.cellToPixel(catCol, catRow, radius);
      // 使用 easeInOut 曲线插值
      final t = Curves.easeInOut.transform(catProgress);
      catOffset = Offset(
        from.x + (to.x - from.x) * t,
        from.y + (to.y - from.y) * t,
      );
      // 添加弹跳效果：Y 轴偏移
      final bounce = sin(t * pi) * radius * 0.2;
      catOffset = Offset(catOffset.dx, catOffset.dy - bounce);
    } else {
      final center = HexNeighbors.cellToPixel(catCol, catRow, radius);
      catOffset = Offset(center.x, center.y);
    }

    final catPainter = TextPainter(
      text: TextSpan(
        text: status == GameStatus.catEscaped ? '🙀' : '🐱',
        style: TextStyle(fontSize: radius * 1.3),
      ),
      textDirection: TextDirection.ltr,
    );
    catPainter.layout();
    catPainter.paint(
      canvas,
      Offset(
        catOffset.dx - catPainter.width / 2,
        catOffset.dy - catPainter.height / 2,
      ),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _HexGridPainter old) {
    return true; // 动画中需要持续重绘
  }
}
