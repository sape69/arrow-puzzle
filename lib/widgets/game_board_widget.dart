import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../game/arrow.dart';
import '../game/game_board.dart';
import 'arrow_exit_animation.dart';
import 'arrow_widget.dart';

class GameBoardWidget extends StatelessWidget {
  const GameBoardWidget({
    super.key,
    required this.board,
    required this.onArrowTap,
    required this.exitingArrow,
    required this.failedArrow,
    required this.onExitFinished,
  });

  final GameBoard board;
  final ValueChanged<Arrow> onArrowTap;
  final Arrow? exitingArrow;
  final Arrow? failedArrow;
  final ValueChanged<Arrow> onExitFinished;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return _buildBoard(constraints);
        },
      ),
    );
  }

  Widget _buildBoard(
    BoxConstraints constraints,
  ) {
    final boardWidth = constraints.maxWidth;

    const padding = 16.0;
    const spacing = 4.0;

    final availableWidth =
        boardWidth -
        (padding * 2) -
        (spacing * (board.size - 1));

    final cellSize = availableWidth / board.size;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.all(padding),
          child: GridView.builder(
            physics:
                const NeverScrollableScrollPhysics(),
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: board.size,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
            ),
            itemCount: board.size * board.size,
            itemBuilder: (context, index) {
              final row = index ~/ board.size;
              final column = index % board.size;

              final arrow = board.arrowAt(
                row,
                column,
              );

              return GestureDetector(
                onTap: arrow == null
                    ? null
                    : () => onArrowTap(arrow),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF21113B),
                    borderRadius:
                        BorderRadius.circular(8),
                  ),
                ),
              );
            },
          ),
        ),
        ..._buildArrowWidgets(
          cellSize,
          spacing,
          padding,
        ),
        if (exitingArrow != null)
          _buildExitAnimation(
            exitingArrow!,
            cellSize,
            spacing,
            padding,
          ),
      ],
    );
  }

  List<Widget> _buildArrowWidgets(
    double cellSize,
    double spacing,
    double padding,
  ) {
    final widgets = <Widget>[];

    for (final arrow in board.arrows) {
      if (arrow == exitingArrow) {
        continue;
      }

      widgets.add(
        _buildArrow(
          arrow,
          cellSize,
          spacing,
          padding,
        ),
      );
    }

    return widgets;
  }

  Widget _buildArrow(
    Arrow arrow,
    double cellSize,
    double spacing,
    double padding,
  ) {
    final isFailed = failedArrow == arrow;
    final bounds = _arrowBounds(arrow);

    return Positioned(
      left: padding +
          bounds.minColumn *
              (cellSize + spacing),
      top: padding +
          bounds.minRow *
              (cellSize + spacing),
      width: _boundsSize(
        bounds.minColumn,
        bounds.maxColumn,
        cellSize,
        spacing,
      ),
      height: _boundsSize(
        bounds.minRow,
        bounds.maxRow,
        cellSize,
        spacing,
      ),
      child: IgnorePointer(
        child: isFailed
            ? _buildFailedArrow(
                arrow,
                cellSize,
              )
            : _buildNormalArrow(
                arrow,
                cellSize,
              ),
      ),
    );
  }

  _ArrowBounds _arrowBounds(
    Arrow arrow,
  ) {
    final cells = board.occupiedCells(arrow);

    var minRow = cells.first.row;
    var maxRow = cells.first.row;
    var minColumn = cells.first.column;
    var maxColumn = cells.first.column;

    for (final cell in cells) {
      minRow = math.min(
        minRow,
        cell.row,
      );

      maxRow = math.max(
        maxRow,
        cell.row,
      );

      minColumn = math.min(
        minColumn,
        cell.column,
      );

      maxColumn = math.max(
        maxColumn,
        cell.column,
      );
    }

    return _ArrowBounds(
      minRow: minRow,
      maxRow: maxRow,
      minColumn: minColumn,
      maxColumn: maxColumn,
    );
  }

  double _boundsSize(
    int min,
    int max,
    double cellSize,
    double spacing,
  ) {
    final cells = max - min + 1;

    return (cells * cellSize) +
        ((cells - 1) * spacing);
  }

  Widget _buildExitAnimation(
    Arrow arrow,
    double cellSize,
    double spacing,
    double padding,
  ) {
    final startX =
        padding +
        arrow.column *
            (cellSize + spacing);

    final startY =
        padding +
        arrow.row *
            (cellSize + spacing);

    return Positioned.fill(
      child: IgnorePointer(
        child: Transform.translate(
          offset: Offset(
            startX,
            startY,
          ),
          child: TweenAnimationBuilder<double>(
            key: ValueKey(
              'exit-${arrow.hashCode}',
            ),
            tween: Tween(
              begin: 0,
              end: 1,
            ),
            duration: const Duration(
              milliseconds: 700,
            ),
            curve: Curves.easeInOut,
            onEnd: () => onExitFinished(arrow),
            builder: (
              context,
              value,
              child,
            ) {
              return ArrowExitAnimation(
                arrow: arrow,
                progress: value,
                cellSize: cellSize,
                spacing: spacing,
                boardSize: board.size,
                color: Colors.green,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNormalArrow(
    Arrow arrow,
    double cellSize,
  ) {
    return Center(
      child: ArrowWidget(
        arrow: arrow,
        cellSize: cellSize,
      ),
    );
  }

  Widget _buildFailedArrow(
    Arrow arrow,
    double cellSize,
  ) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(
        'failed-${arrow.hashCode}',
      ),
      tween: Tween(
        begin: 0,
        end: 1,
      ),
      duration: const Duration(
        milliseconds: 650,
      ),
      curve: Curves.easeInOut,
      builder: (
        context,
        value,
        child,
      ) {
        final offset = _collisionOffset(
          arrow,
          value,
          cellSize,
        );

        return Transform.translate(
          offset: offset,
          child: child,
        );
      },
      child: Center(
        child: ArrowWidget(
          arrow: arrow,
          cellSize: cellSize,
          color: Colors.red,
        ),
      ),
    );
  }

  Offset _collisionOffset(
    Arrow arrow,
    double value,
    double cellSize,
  ) {
    final collisionDistance = math.min(
      24.0,
      cellSize * 0.45,
    );

    final movement = value <= 0.5
        ? value * 2 * collisionDistance
        : (1 - value) *
            2 *
            collisionDistance;

    final direction = arrow.isBent
        ? arrow.path.first
        : arrow.direction;

    switch (direction) {
      case ArrowDirection.up:
        return Offset(
          0,
          -movement,
        );

      case ArrowDirection.right:
        return Offset(
          movement,
          0,
        );

      case ArrowDirection.down:
        return Offset(
          0,
          movement,
        );

      case ArrowDirection.left:
        return Offset(
          -movement,
          0,
        );
    }
  }
}

class _ArrowBounds {
  const _ArrowBounds({
    required this.minRow,
    required this.maxRow,
    required this.minColumn,
    required this.maxColumn,
  });

  final int minRow;
  final int maxRow;
  final int minColumn;
  final int maxColumn;
}