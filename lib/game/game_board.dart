import 'arrow.dart';
import 'level_data.dart';

class GameBoard {
  GameBoard() {
    reset();
  }

  int currentLevel = 0;

  final List<Arrow> arrows = [];

  int get size => levels[currentLevel].size;

  void reset() {
    arrows
      ..clear()
      ..addAll(levels[currentLevel].arrows);
  }

  bool nextLevel() {
    if (currentLevel >= levels.length - 1) {
      return false;
    }

    currentLevel++;
    reset();
    return true;
  }

  Arrow? arrowAt(
    int row,
    int column,
  ) {
    for (final arrow in arrows) {
      final cells = occupiedCells(arrow);

      for (final cell in cells) {
        if (cell.row == row &&
            cell.column == column) {
          return arrow;
        }
      }
    }

    return null;
  }

  List<GridPosition> occupiedCells(
    Arrow arrow,
  ) {
    final cells = <GridPosition>[];

    var row = arrow.row;
    var column = arrow.column;

    cells.add(
      GridPosition(
        row: row,
        column: column,
      ),
    );

    if (arrow.isBent) {
      for (final direction in arrow.path) {
        final next = _move(
          row,
          column,
          direction,
        );

        row = next.row;
        column = next.column;

        cells.add(
          GridPosition(
            row: row,
            column: column,
          ),
        );
      }

      return cells;
    }

    for (var i = 1; i < arrow.length; i++) {
      final next = _move(
        row,
        column,
        arrow.direction,
      );

      row = next.row;
      column = next.column;

      cells.add(
        GridPosition(
          row: row,
          column: column,
        ),
      );
    }

    return cells;
  }

  GridPosition arrowTip(
    Arrow arrow,
  ) {
    final cells = occupiedCells(arrow);

    return cells.last;
  }

  ArrowDirection exitDirection(
    Arrow arrow,
  ) {
    if (arrow.isBent) {
      return arrow.path.last;
    }

    return arrow.direction;
  }

  bool canExit(
    Arrow arrow,
  ) {
    final tip = arrowTip(arrow);
    final direction = exitDirection(arrow);

    var row = tip.row;
    var column = tip.column;

    while (true) {
      final next = _move(
        row,
        column,
        direction,
      );

      row = next.row;
      column = next.column;

      if (!_isInsideBoard(row, column)) {
        return true;
      }

      final blockingArrow = arrowAt(
        row,
        column,
      );

      if (blockingArrow != null &&
          blockingArrow != arrow) {
        return false;
      }
    }
  }

  bool _isInsideBoard(
    int row,
    int column,
  ) {
    return row >= 0 &&
        row < size &&
        column >= 0 &&
        column < size;
  }

  GridPosition _move(
    int row,
    int column,
    ArrowDirection direction,
  ) {
    switch (direction) {
      case ArrowDirection.up:
        return GridPosition(
          row: row - 1,
          column: column,
        );

      case ArrowDirection.right:
        return GridPosition(
          row: row,
          column: column + 1,
        );

      case ArrowDirection.down:
        return GridPosition(
          row: row + 1,
          column: column,
        );

      case ArrowDirection.left:
        return GridPosition(
          row: row,
          column: column - 1,
        );
    }
  }

  void removeArrow(
    Arrow arrow,
  ) {
    arrows.remove(arrow);
  }
}

class GridPosition {
  const GridPosition({
    required this.row,
    required this.column,
  });

  final int row;
  final int column;
}