import 'dart:math';

import 'arrow.dart';
import 'level_data.dart';

class LevelGenerator {
  const LevelGenerator();

  LevelData generate({
    required int size,
    required int arrowCount,
    int seed = 1,
  }) {
    final random = Random(seed);
    final arrows = <Arrow>[];

    final cells = <_Cell>[];

    for (var row = 0; row < size; row++) {
      for (var column = 0; column < size; column++) {
        cells.add(
          _Cell(
            row: row,
            column: column,
          ),
        );
      }
    }

    cells.shuffle(random);

    for (final cell in cells) {
      if (arrows.length >= arrowCount) {
        break;
      }

      final direction = _randomDirection(random);
      final maxLength = _maxLength(
        cell,
        direction,
        size,
      );

      if (maxLength < 1) {
        continue;
      }

      final length = 1 +
          random.nextInt(
            min(maxLength, 3),
          );

      final arrow = Arrow(
        row: cell.row,
        column: cell.column,
        direction: direction,
        length: length,
      );

      if (_overlaps(
        arrow,
        arrows,
      )) {
        continue;
      }

      if (!_exitPathIsClear(
        arrow,
        arrows,
        size,
      )) {
        continue;
      }

      arrows.add(arrow);
    }

    return LevelData(
      size: size,
      arrows: arrows,
    );
  }

  ArrowDirection _randomDirection(
    Random random,
  ) {
    return ArrowDirection.values[
      random.nextInt(
        ArrowDirection.values.length,
      )
    ];
  }

  int _maxLength(
    _Cell cell,
    ArrowDirection direction,
    int size,
  ) {
    switch (direction) {
      case ArrowDirection.up:
        return cell.row + 1;

      case ArrowDirection.right:
        return size - cell.column;

      case ArrowDirection.down:
        return size - cell.row;

      case ArrowDirection.left:
        return cell.column + 1;
    }
  }

  bool _overlaps(
    Arrow arrow,
    List<Arrow> arrows,
  ) {
    for (final other in arrows) {
      if (_occupiesSameCell(
        arrow,
        other,
      )) {
        return true;
      }
    }

    return false;
  }

  bool _occupiesSameCell(
    Arrow first,
    Arrow second,
  ) {
    final firstCells = _occupiedCells(first);
    final secondCells = _occupiedCells(second);

    for (final firstCell in firstCells) {
      for (final secondCell in secondCells) {
        if (firstCell == secondCell) {
          return true;
        }
      }
    }

    return false;
  }

  Set<_Cell> _occupiedCells(
    Arrow arrow,
  ) {
    final result = <_Cell>{};

    var row = arrow.row;
    var column = arrow.column;

    result.add(
      _Cell(
        row: row,
        column: column,
      ),
    );

    for (var i = 1; i < arrow.length; i++) {
      final next = _move(
        row,
        column,
        arrow.direction,
      );

      row = next.row;
      column = next.column;

      result.add(
        _Cell(
          row: row,
          column: column,
        ),
      );
    }

    return result;
  }

  bool _exitPathIsClear(
    Arrow arrow,
    List<Arrow> existing,
    int size,
  ) {
    var row = arrow.row;
    var column = arrow.column;

    for (var i = 1; i < arrow.length; i++) {
      final next = _move(
        row,
        column,
        arrow.direction,
      );

      row = next.row;
      column = next.column;
    }

    while (true) {
      final next = _move(
        row,
        column,
        arrow.direction,
      );

      row = next.row;
      column = next.column;

      if (row < 0 ||
          row >= size ||
          column < 0 ||
          column >= size) {
        return true;
      }

      for (final other in existing) {
        if (_occupiesCell(
          other,
          row,
          column,
        )) {
          return false;
        }
      }
    }
  }

  bool _occupiesCell(
    Arrow arrow,
    int row,
    int column,
  ) {
    for (final cell in _occupiedCells(arrow)) {
      if (cell.row == row &&
          cell.column == column) {
        return true;
      }
    }

    return false;
  }

  _Cell _move(
    int row,
    int column,
    ArrowDirection direction,
  ) {
    switch (direction) {
      case ArrowDirection.up:
        return _Cell(
          row: row - 1,
          column: column,
        );

      case ArrowDirection.right:
        return _Cell(
          row: row,
          column: column + 1,
        );

      case ArrowDirection.down:
        return _Cell(
          row: row + 1,
          column: column,
        );

      case ArrowDirection.left:
        return _Cell(
          row: row,
          column: column - 1,
        );
    }
  }
}

class _Cell {
  const _Cell({
    required this.row,
    required this.column,
  });

  final int row;
  final int column;

  @override
  bool operator ==(Object other) {
    return other is _Cell &&
        other.row == row &&
        other.column == column;
  }

  @override
  int get hashCode => Object.hash(
        row,
        column,
      );
}