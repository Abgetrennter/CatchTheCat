import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/game_constants.dart';
import '../../../domain/models/game_state.dart';
import '../../../domain/services/hex_neighbors.dart';
import '../game_notifier.dart';

class HexGrid extends ConsumerWidget {
  const HexGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final radius = GameConstants.maxRadius(
          constraints.maxWidth,
          constraints.maxHeight,
        );

        return GestureDetector(
          onTapUp: (details) {
            final renderBox = context.findRenderObject() as RenderBox;
            final localPos = renderBox.globalToLocal(details.globalPosition);

            final gridWidth =
                GameConstants.gridWidth * radius * 2 + radius;
            final gridHeight =
                GameConstants.gridHeight * radius * sqrt(3);
            final offsetX = (constraints.maxWidth - gridWidth) / 2;
            final offsetY = (constraints.maxHeight - gridHeight) / 2;

            final adjustedX = localPos.dx - offsetX;
            final adjustedY = localPos.dy - offsetY;

            final cell = HexNeighbors.pixelToCell(
              adjustedX,
              adjustedY,
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
            ),
          ),
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

  _HexGridPainter({
    required this.grid,
    required this.catCol,
    required this.catRow,
    required this.radius,
    required this.status,
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

    final emptyPaint = Paint()..color = GameConstants.emptyColor;
    final wallPaint = Paint()..color = GameConstants.wallColor;
    final strokePaint = Paint()
      ..color = const Color(0xFF80BFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // 绘制所有格子
    for (var row = 0; row < h; row++) {
      for (var col = 0; col < w; col++) {
        final center = HexNeighbors.cellToPixel(col, row, radius);
        final isWall = grid[col][row];
        final isCat = col == catCol && row == catRow;
        final drawRadius = radius * 0.85;

        if (isCat && status == GameStatus.playerWin) {
          canvas.drawCircle(
            Offset(center.x, center.y),
            drawRadius,
            Paint()..color = GameConstants.catCaughtColor,
          );
        } else {
          canvas.drawCircle(
            Offset(center.x, center.y),
            drawRadius,
            isWall ? wallPaint : emptyPaint,
          );
          if (!isWall) {
            canvas.drawCircle(
              Offset(center.x, center.y),
              drawRadius,
              strokePaint,
            );
          }
        }
      }
    }

    // 绘制猫咪 Emoji
    final catCenter = HexNeighbors.cellToPixel(catCol, catRow, radius);
    final catTextPainter = TextPainter(
      text: TextSpan(
        text: status == GameStatus.catEscaped ? '🙀' : '🐱',
        style: TextStyle(fontSize: radius * 1.3),
      ),
      textDirection: TextDirection.ltr,
    );
    catTextPainter.layout();
    catTextPainter.paint(
      canvas,
      Offset(
        catCenter.x - catTextPainter.width / 2,
        catCenter.y - catTextPainter.height / 2,
      ),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _HexGridPainter oldDelegate) {
    return oldDelegate.catCol != catCol ||
        oldDelegate.catRow != catRow ||
        oldDelegate.grid != grid ||
        oldDelegate.status != status ||
        oldDelegate.radius != radius;
  }
}
