import 'arrow.dart';
import 'level_data.dart';

class GameBoard {
  GameBoard({
    this.size = 7,
  }) {
    reset();
  }

  final int size;

  int currentLevel = 0;

  final List<Arrow> arrows = [];

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

  Arrow? arrowAt(int row, int column) {
    for (final arrow in arrows) {
      if (_occupiesCell(arrow, row, column)) {
        return arrow;
      }
    }

    return null;
  }

  bool _occupiesCell(
    Arrow arrow,
    int row,
    int column,
  ) {
    var currentRow = arrow.row;
    var currentColumn = arrow.column;

    if (currentRow == row && currentColumn == column) {
      return true;
    }

    if (!arrow.isBent) {
      for (var i = 1; i < arrow.length; i++) {
        switch (arrow.direction) {
          case ArrowDirection.up:
            currentRow--;
            break;
          case ArrowDirection.right:
            currentColumn++;
            break;
          case ArrowDirection.down:
            currentRow++;
            break;
          case ArrowDirection.left:
            currentColumn--;
            break;
        }

        if (currentRow == row && currentColumn == column) {
          return true;
        }
      }

      return false;
    }

    for (final direction in arrow.path!) {
      switch (direction) {
        case ArrowDirection.up:
          currentRow--;
          break;
        case ArrowDirection.right:
          currentColumn++;
          break;
        case ArrowDirection.down:
          currentRow++;
          break;
        case ArrowDirection.left:
          currentColumn--;
          break;
      }

      if (currentRow == row && currentColumn == column) {
        return true;
      }
    }

    return false;
  }

  bool canExit(Arrow arrow) {
    var row = arrow.row;
    var column = arrow.column;

    if (arrow.isBent) {
      for (final direction in arrow.path!) {
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
      }

      return _pathToExit(
        arrow,
        row,
        column,
        arrow.path!.last,
      );
    }

    switch (arrow.direction) {
      case ArrowDirection.up:
        row -= arrow.length;
        break;
      case ArrowDirection.right:
        column += arrow.length;
        break;
      case ArrowDirection.down:
        row += arrow.length;
        break;
      case ArrowDirection.left:
        column -= arrow.length;
        break;
    }

    return _pathToExit(
      arrow,
      row,
      column,
      arrow.direction,
    );
  }

  bool _pathToExit(
    Arrow arrow,
    int row,
    int column,
    ArrowDirection direction,
  ) {
    while (true) {
      if (row < 0 ||
          row >= size ||
          column < 0 ||
          column >= size) {
        return true;
      }

      final blockingArrow = arrowAt(row, column);

      if (blockingArrow != null && blockingArrow != arrow) {
        return false;
      }

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
    }
  }

  void removeArrow(Arrow arrow) {
    arrows.remove(arrow);
  }
}