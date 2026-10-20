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
      if (_occupiesCell(
        arrow,
        row,
        column,
      )) {
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

    if (currentRow == row &&
        currentColumn == column) {
      return true;
    }

    if (!arrow.isBent) {
      for (var i = 1; i < arrow.length; i++) {
        final next = _move(
          currentRow,
          currentColumn,
          arrow.direction,
        );

        currentRow = next.row;
        currentColumn = next.column;

        if (currentRow == row &&
            currentColumn == column) {
          return true;
        }
      }

      return false;
    }

    for (final direction in arrow.path!) {
      final next = _move(
        currentRow,
        currentColumn,
        direction,
      );

      currentRow = next.row;
      currentColumn = next.column;

      if (currentRow == row &&
          currentColumn == column) {
        return true;
      }
    }

    return false;
  }

  bool canExit(Arrow arrow) {
    final tip = _arrowTip(arrow);

    return _clearToEdge(
      arrow,
      tip.row,
      tip.column,
      tip.direction,
    );
  }

  _ArrowTip _arrowTip(Arrow arrow) {
    var row = arrow.row;
    var column = arrow.column;
    var direction = arrow.direction;

    if (arrow.isBent) {
      for (final pathDirection in arrow.path!) {
        final next = _move(
          row,
          column,
          pathDirection,
        );

        row = next.row;
        column = next.column;
        direction = pathDirection;
      }

      return _ArrowTip(
        row: row,
        column: column,
        direction: direction,
      );
    }

    for (var i = 1; i < arrow.length; i++) {
      final next = _move(
        row,
        column,
        arrow.direction,
      );

      row = next.row;
      column = next.column;
    }

    return _ArrowTip(
      row: row,
      column: column,
      direction: arrow.direction,
    );
  }

  bool _clearToEdge(
    Arrow arrow,
    int row,
    int column,
    ArrowDirection direction,
  ) {
    var currentRow = row;
    var currentColumn = column;

    while (true) {
      final next = _move(
        currentRow,
        currentColumn,
        direction,
      );

      currentRow = next.row;
      currentColumn = next.column;

      if (currentRow < 0 ||
          currentRow >= size ||
          currentColumn < 0 ||
          currentColumn >= size) {
        return true;
      }

      final blockingArrow = arrowAt(
        currentRow,
        currentColumn,
      );

      if (blockingArrow != null &&
          blockingArrow != arrow) {
        return false;
      }
    }
  }

  _GridPosition _move(
    int row,
    int column,
    ArrowDirection direction,
  ) {
    switch (direction) {
      case ArrowDirection.up:
        return _GridPosition(
          row: row - 1,
          column: column,
        );

      case ArrowDirection.right:
        return _GridPosition(
          row: row,
          column: column + 1,
        );

      case ArrowDirection.down:
        return _GridPosition(
          row: row + 1,
          column: column,
        );

      case ArrowDirection.left:
        return _GridPosition(
          row: row,
          column: column - 1,
        );
    }
  }

  void removeArrow(Arrow arrow) {
    arrows.remove(arrow);
  }
}

class _ArrowTip {
  const _ArrowTip({
    required this.row,
    required this.column,
    required this.direction,
  });

  final int row;
  final int column;
  final ArrowDirection direction;
}

class _GridPosition {
  const _GridPosition({
    required this.row,
    required this.column,
  });

  final int row;
  final int column;
}