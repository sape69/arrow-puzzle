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
    for (var i = 0; i < arrow.length; i++) {
      var arrowRow = arrow.row;
      var arrowColumn = arrow.column;

      switch (arrow.direction) {
        case ArrowDirection.up:
          arrowRow -= i;
          break;
        case ArrowDirection.right:
          arrowColumn += i;
          break;
        case ArrowDirection.down:
          arrowRow += i;
          break;
        case ArrowDirection.left:
          arrowColumn -= i;
          break;
      }

      if (arrowRow == row && arrowColumn == column) {
        return true;
      }
    }

    return false;
  }

  bool canExit(Arrow arrow) {
    var row = arrow.row;
    var column = arrow.column;

    while (true) {
      switch (arrow.direction) {
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
    }
  }

  void removeArrow(Arrow arrow) {
    arrows.remove(arrow);
  }
}