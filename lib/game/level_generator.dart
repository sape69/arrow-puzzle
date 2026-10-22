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
    final available = <_Cell>[
      for (var row = 0; row < size; row++)
        for (var column = 0; column < size; column++)
          _Cell(
            row: row,
            column: column,
          ),
    ];

    available.shuffle(random);

    for (final cell in available) {
      if (arrows.length >= arrowCount) {
        break;
      }

      final direction = _directionToEdge(
        cell,
        size,
        random,
      );

      final maxLength = _maxLength(
        cell,
        direction,
        size,
      );

      if (maxLength < 1) {
        continue;
      }

      final length = _randomLength(
        maxLength,
        random,
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

      arrows.add(arrow);
    }

    return LevelData(
      size: size,
      arrows: arrows,
    );
  }

  ArrowDirection _directionToEdge(
    _Cell cell,
    int size,
    Random random,
  ) {
    final distances = <ArrowDirection, int>{
      ArrowDirection.up: cell.row + 1,
      ArrowDirection.right: size - cell.column,
      ArrowDirection.down: size - cell.row,
      ArrowDirection.left: cell.column + 1,
    };

    final minimum =
        distances.values.reduce(min);

    final directions = distances.entries
        .where(
          (entry) => entry.value == minimum,
        )
        .map(
          (entry) => entry.key,
        )
        .toList();

    return directions[
        random.nextInt(directions.length)];
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

  int _randomLength(
    int maxLength,
    Random random,
  ) {
    final limit = min(
      maxLength,
      3,
    );

    return 1 + random.nextInt(limit);
  }

  bool _overlaps(
    Arrow arrow,
    List<Arrow> arrows,
  ) {
    final occupied = _occupiedCells(arrow);

    for (final other in arrows) {
      final otherCells =
          _occupiedCells(other);

      for (final cell in occupied) {
        if (otherCells.contains(cell)) {
          return true;
        }
      }
    }

    return false;
  }

  Set<_Cell> _occupiedCells(
    Arrow arrow,
  ) {
    final cells = <_Cell>{};

    var row = arrow.row;
    var column = arrow.column;

    cells.add(
      _Cell(
        row: row,
        column: column,
      ),
    );

    for (var i = 1; i < arrow.length; i++) {
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

      cells.add(
        _Cell(
          row: row,
          column: column,
        ),
      );
    }

    return cells;
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
  int get hashCode {
    return Object.hash(
      row,
      column,
    );
  }
}