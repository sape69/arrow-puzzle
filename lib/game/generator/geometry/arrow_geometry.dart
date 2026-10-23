import '../../arrow.dart';

class GridCell {
  const GridCell({
    required this.row,
    required this.column,
  });

  final int row;
  final int column;

  GridCell move(ArrowDirection direction) {
    switch (direction) {
      case ArrowDirection.up:
        return GridCell(
          row: row - 1,
          column: column,
        );

      case ArrowDirection.right:
        return GridCell(
          row: row,
          column: column + 1,
        );

      case ArrowDirection.down:
        return GridCell(
          row: row + 1,
          column: column,
        );

      case ArrowDirection.left:
        return GridCell(
          row: row,
          column: column - 1,
        );
    }
  }

  @override
  bool operator ==(Object other) {
    return other is GridCell &&
        other.row == row &&
        other.column == column;
  }

  @override
  int get hashCode {
    return Object.hash(
      row,
      column,
    );
  }

  @override
  String toString() {
    return 'GridCell($row, $column)';
  }
}

class ArrowGeometry {
  const ArrowGeometry();

  List<GridCell> cells(Arrow arrow) {
    final result = <GridCell>[];

    var current = GridCell(
      row: arrow.row,
      column: arrow.column,
    );

    result.add(current);

    if (arrow.isBent) {
      for (final direction in arrow.path) {
        current = current.move(direction);
        result.add(current);
      }

      return result;
    }

    for (var i = 1; i < arrow.length; i++) {
      current = current.move(
        arrow.direction,
      );

      result.add(current);
    }

    return result;
  }

  GridCell tip(Arrow arrow) {
    final arrowCells = cells(arrow);

    return arrowCells.last;
  }

  ArrowDirection exitDirection(Arrow arrow) {
    if (arrow.isBent) {
      return arrow.path.last;
    }

    return arrow.direction;
  }

  bool isInside(
    GridCell cell,
    int boardSize,
  ) {
    return cell.row >= 0 &&
        cell.row < boardSize &&
        cell.column >= 0 &&
        cell.column < boardSize;
  }

  bool isInsideBoard(
    Arrow arrow,
    int boardSize,
  ) {
    for (final cell in cells(arrow)) {
      if (!isInside(
        cell,
        boardSize,
      )) {
        return false;
      }
    }

    return true;
  }

  bool isSelfIntersecting(Arrow arrow) {
    final occupied = <GridCell>{};

    for (final cell in cells(arrow)) {
      if (!occupied.add(cell)) {
        return true;
      }
    }

    return false;
  }

  bool isValidPath(
    Arrow arrow,
    int boardSize,
  ) {
    if (arrow.isBent && arrow.path.isEmpty) {
      return false;
    }

    if (arrow.length < 1) {
      return false;
    }

    if (!isInsideBoard(
      arrow,
      boardSize,
    )) {
      return false;
    }

    if (isSelfIntersecting(arrow)) {
      return false;
    }

    return true;
  }
}