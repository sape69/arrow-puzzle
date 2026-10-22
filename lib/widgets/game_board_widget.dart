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

    final cellSize =
        availableWidth / board.size;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) {
        final arrow = _arrowAtPoint(
          details.localPosition,
          cellSize,
          spacing,
          padding,
        );

        if (arrow != null) {
          onArrowTap(arrow);
        }
      },
      child: Stack(
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
              itemCount:
                  board.size * board.size,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color:
                        const Color(0xFF21113B),
                    borderRadius:
                        BorderRadius.circular(8),
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
      ),
    );
  }

  Arrow? _arrowAtPoint(
    Offset point,
    double cellSize,
    double spacing,
    double padding,
  ) {
    Arrow? closestArrow;
    var closestDistance = double.infinity;

    for (final arrow in board.arrows) {
      if (arrow == exitingArrow ||
          arrow == failedArrow) {
        continue;
      }

      final left = _arrowLeft(
        arrow,
        cellSize,
        spacing,
        padding,
      );

      final top = _arrowTop(
        arrow,
        cellSize,
        spacing,
        padding,
      );

      final width = _arrowWidth(
        arrow,
        cellSize,
        spacing,
      );

      final height = _arrowHeight(
        arrow,
        cellSize,
        spacing,
      );

      if (point.dx < left ||
          point.dx > left + width ||
          point.dy < top ||
          point.dy > top + height) {
        continue;
      }

      final localPoint = Offset(
        point.dx - left,
        point.dy - top,
      );

      final distance = _arrowDistance(
        arrow,
        localPoint,
        cellSize,
        spacing,
      );

      if (distance != null &&
          distance < closestDistance) {
        closestDistance = distance;
        closestArrow = arrow;
      }
    }

    return closestArrow;
  }

  double? _arrowDistance(
    Arrow arrow,
    Offset point,
    double cellSize,
    double spacing,
  ) {
    final tolerance = math.max(
      12.0,
      cellSize * 0.18,
    );

    if (arrow.isBent) {
      return _bentArrowDistance(
        arrow,
        point,
        cellSize,
        spacing,
        tolerance,
      );
    }

    return _straightArrowDistance(
      arrow,
      point,
      cellSize,
      spacing,
      tolerance,
    );
  }

  double? _straightArrowDistance(
    Arrow arrow,
    Offset point,
    double cellSize,
    double spacing,
    double tolerance,
  ) {
    final center = cellSize / 2;
    final step = cellSize + spacing;

    Offset start;
    Offset end;

    switch (arrow.direction) {
      case ArrowDirection.right:
        start = Offset(
          center,
          center,
        );
        end = Offset(
          center +
              ((arrow.length - 1) * step),
          center,
        );
        break;

      case ArrowDirection.left:
        start = Offset(
          center +
              ((arrow.length - 1) * step),
          center,
        );
        end = Offset(
          center,
          center,
        );
        break;

      case ArrowDirection.down:
        start = Offset(
          center,
          center,
        );
        end = Offset(
          center,
          center +
              ((arrow.length - 1) * step),
        );
        break;

      case ArrowDirection.up:
        start = Offset(
          center,
          center +
              ((arrow.length - 1) * step),
        );
        end = Offset(
          center,
          center,
        );
        break;
    }

    final distance = _distanceToSegment(
      point,
      start,
      end,
    );

    if (distance > tolerance) {
      return null;
    }

    return distance;
  }

  double? _bentArrowDistance(
    Arrow arrow,
    Offset point,
    double cellSize,
    double spacing,
    double tolerance,
  ) {
    final step = cellSize + spacing;
    final bounds = _bentBounds(arrow);

    var column = -bounds.minColumn;
    var row = -bounds.minRow;

    var previous = Offset(
      (column * step) +
          (cellSize / 2),
      (row * step) +
          (cellSize / 2),
    );

    var closestDistance = double.infinity;

    for (final direction in arrow.path) {
      switch (direction) {
        case ArrowDirection.up:
          row--;
          break;

        case ArrowDirection.right:
          column++;
          break;

        case ArrowDirection.down:
          row++;
          break;

        case ArrowDirection.left:
          column--;
          break;
      }

      final current = Offset(
        (column * step) +
            (cellSize / 2),
        (row * step) +
            (cellSize / 2),
      );

      final distance = _distanceToSegment(
        point,
        previous,
        current,
      );

      if (distance < closestDistance) {
        closestDistance = distance;
      }

      previous = current;
    }

    if (closestDistance > tolerance) {
      return null;
    }

    return closestDistance;
  }

  double _distanceToSegment(
    Offset point,
    Offset start,
    Offset end,
  ) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;

    if (dx == 0 && dy == 0) {
      return (point - start).distance;
    }

    final lengthSquared =
        (dx * dx) + (dy * dy);

    var t =
        ((point.dx - start.dx) * dx +
                (point.dy - start.dy) * dy) /
            lengthSquared;

    t = t.clamp(0.0, 1.0);

    final projection = Offset(
      start.dx + (t * dx),
      start.dy + (t * dy),
    );

    return (point - projection).distance;
  }

  _BentBounds _bentBounds(
    Arrow arrow,
  ) {
    var row = 0;
    var column = 0;

    var minRow = 0;
    var minColumn = 0;

    for (final direction in arrow.path) {
      switch (direction) {
        case ArrowDirection.up:
          row--;
          break;

        case ArrowDirection.right:
          column++;
          break;

        case ArrowDirection.down:
          row++;
          break;

        case ArrowDirection.left:
          column--;
          break;
      }

      minRow = math.min(
        minRow,
        row,
      );

      minColumn = math.min(
        minColumn,
        column,
      );
    }

    return _BentBounds(
      minRow: minRow,
      minColumn: minColumn,
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

    return Positioned(
      left: _arrowLeft(
        arrow,
        cellSize,
        spacing,
        padding,
      ),
      top: _arrowTop(
        arrow,
        cellSize,
        spacing,
        padding,
      ),
      width: _arrowWidth(
        arrow,
        cellSize,
        spacing,
      ),
      height: _arrowHeight(
        arrow,
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
        'failed-$arrow',
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

  double _arrowWidth(
    Arrow arrow,
    double cellSize,
    double spacing,
  ) {
    if (arrow.isBent) {
      return _bentWidth(
        arrow,
        cellSize,
        spacing,
      );
    }

    if (arrow.direction ==
            ArrowDirection.left ||
        arrow.direction ==
            ArrowDirection.right) {
      return _arrowLength(
        arrow,
        cellSize,
        spacing,
      );
    }

    return cellSize;
  }

  double _arrowHeight(
    Arrow arrow,
    double cellSize,
    double spacing,
  ) {
    if (arrow.isBent) {
      return _bentHeight(
        arrow,
        cellSize,
        spacing,
      );
    }

    if (arrow.direction ==
            ArrowDirection.up ||
        arrow.direction ==
            ArrowDirection.down) {
      return _arrowLength(
        arrow,
        cellSize,
        spacing,
      );
    }

    return cellSize;
  }

  double _arrowLength(
    Arrow arrow,
    double cellSize,
    double spacing,
  ) {
    return (arrow.length * cellSize) +
        ((arrow.length - 1) * spacing);
  }

  double _bentWidth(
    Arrow arrow,
    double cellSize,
    double spacing,
  ) {
    var column = 0;
    var minColumn = 0;
    var maxColumn = 0;

    for (final direction in arrow.path) {
      switch (direction) {
        case ArrowDirection.left:
          column--;
          break;

        case ArrowDirection.right:
          column++;
          break;

        case ArrowDirection.up:
        case ArrowDirection.down:
          break;
      }

      minColumn = math.min(
        minColumn,
        column,
      );

      maxColumn = math.max(
        maxColumn,
        column,
      );
    }

    return ((maxColumn - minColumn + 1) *
            cellSize) +
        ((maxColumn - minColumn) *
            spacing);
  }

  double _bentHeight(
    Arrow arrow,
    double cellSize,
    double spacing,
  ) {
    var row = 0;
    var minRow = 0;
    var maxRow = 0;

    for (final direction in arrow.path) {
      switch (direction) {
        case ArrowDirection.up:
          row--;
          break;

        case ArrowDirection.down:
          row++;
          break;

        case ArrowDirection.left:
        case ArrowDirection.right:
          break;
      }

      minRow = math.min(
        minRow,
        row,
      );

      maxRow = math.max(
        maxRow,
        row,
      );
    }

    return ((maxRow - minRow + 1) *
            cellSize) +
        ((maxRow - minRow) *
            spacing);
  }

  double _arrowLeft(
    Arrow arrow,
    double cellSize,
    double spacing,
    double padding,
  ) {
    if (arrow.isBent) {
      return _bentLeft(
        arrow,
        cellSize,
        spacing,
        padding,
      );
    }

    if (arrow.direction ==
        ArrowDirection.left) {
      return padding +
          (arrow.column -
                  arrow.length +
                  1) *
              (cellSize + spacing);
    }

    return padding +
        arrow.column *
            (cellSize + spacing);
  }

  double _arrowTop(
    Arrow arrow,
    double cellSize,
    double spacing,
    double padding,
  ) {
    if (arrow.isBent) {
      return _bentTop(
        arrow,
        cellSize,
        spacing,
        padding,
      );
    }

    if (arrow.direction ==
        ArrowDirection.up) {
      return padding +
          (arrow.row -
                  arrow.length +
                  1) *
              (cellSize + spacing);
    }

    return padding +
        arrow.row *
            (cellSize + spacing);
  }

  double _bentLeft(
    Arrow arrow,
    double cellSize,
    double spacing,
    double padding,
  ) {
    var column = 0;
    var minColumn = 0;

    for (final direction in arrow.path) {
      if (direction ==
          ArrowDirection.left) {
        column--;
      } else if (direction ==
          ArrowDirection.right) {
        column++;
      }

      minColumn = math.min(
        minColumn,
        column,
      );
    }

    return padding +
        (arrow.column + minColumn) *
            (cellSize + spacing);
  }

  double _bentTop(
    Arrow arrow,
    double cellSize,
    double spacing,
    double padding,
  ) {
    var row = 0;
    var minRow = 0;

    for (final direction in arrow.path) {
      if (direction ==
          ArrowDirection.up) {
        row--;
      } else if (direction ==
          ArrowDirection.down) {
        row++;
      }

      minRow = math.min(
        minRow,
        row,
      );
    }

    return padding +
        (arrow.row + minRow) *
            (cellSize + spacing);
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
        ? value *
            2 *
            collisionDistance
        : (1 - value) *
            2 *
            collisionDistance;

    switch (arrow.direction) {
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

class _BentBounds {
  const _BentBounds({
    required this.minRow,
    required this.minColumn,
  });

  final int minRow;
  final int minColumn;
}

Tässä on nyt tärkeä ero: nuolten omat kosketuskuuntelijat on poistettu kokonaan. Siksi yksi nuoli ei voi enää vahingossa peittää toisen kosketusaluetta.

Lisäksi jos kaksi nuolta ovat lähellä toisiaan, valitaan se, jonka todellinen viiva on lähimpänä sormen kosketuskohtaa.

Tämä on mielestäni paljon oikeampi pohja ennen kuin tehdään Level 9 → 10 → 20 jne.

Valmis → aja ensin "flutter analyze" ja sitten testaa Level 7–8:n nuolet.