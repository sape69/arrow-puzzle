import 'arrow.dart';

class GameBoard {
  GameBoard({
    this.size = 7,
  }) {
    reset();
  }

  final int size;

  final List<Arrow> arrows = [];

  void reset() {
    arrows
      ..clear()
      ..addAll([
        const Arrow(
          row: 1,
          column: 1,
          direction: ArrowDirection.up,
        ),
        const Arrow(
          row: 1,
          column: 2,
          direction: ArrowDirection.up,
        ),
        const Arrow(
          row: 1,
          column: 3,
          direction: ArrowDirection.up,
        ),
        const Arrow(
          row: 1,
          column: 4,
          direction: ArrowDirection.up,
        ),
        const Arrow(
          row: 2,
          column: 1,
          direction: ArrowDirection.left,
        ),
        const Arrow(
          row: 2,
          column: 3,
          direction: ArrowDirection.up,
        ),
        const Arrow(
          row: 2,
          column: 5,
          direction: ArrowDirection.right,
        ),
        const Arrow(
          row: 3,
          column: 1,
          direction: ArrowDirection.left,
        ),
        const Arrow(
          row: 3,
          column: 2,
          direction: ArrowDirection.down,
        ),
        const Arrow(
          row: 3,
          column: 3,
          direction: ArrowDirection.right,
        ),
        const Arrow(
          row: 3,
          column: 4,
          direction: ArrowDirection.down,
        ),
        const Arrow(
          row: 3,
          column: 5,
          direction: ArrowDirection.right,
        ),
      ]);
  }

  Arrow? arrowAt(int row, int column) {
    for (final arrow in arrows) {
      if (arrow.row == row && arrow.column == column) {
        return arrow;
      }
    }

    return null;
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

      if (arrowAt(row, column) != null) {
        return false;
      }
    }
  }

  void removeArrow(Arrow arrow) {
    arrows.remove(arrow);
  }
}