import 'dart:math';

import 'arrow.dart';
import 'level_data.dart';
import 'level_solver.dart';
import 'game_board.dart';

class LevelGenerator {
  const LevelGenerator();

  LevelData generate({
    required int size,
    required int arrowCount,
    int seed = 1,
    int maxAttempts = 1000,
  }) {
    final random = Random(seed);

    for (var attempt = 0;
        attempt < maxAttempts;
        attempt++) {
      final level = _generateCandidate(
        size: size,
        arrowCount: arrowCount,
        random: random,
      );

      if (level.arrows.length != arrowCount) {
        continue;
      }

      final board = GameBoard(level: level);
      const solver = LevelSolver();

      if (solver.isSolvable(board)) {
        return level;
      }
    }

    throw StateError(
      'Could not generate a solvable level '
      'after $maxAttempts attempts.',
    );
  }

  LevelData _generateCandidate({
    required int size,
    required int arrowCount,
    required Random random,
  }) {
    final arrows = <Arrow>[];

    final cells = <_Cell>[
      for (var row = 0; row < size; row++)
        for (var column = 0; column < size; column++)
          _Cell(
            row: row,
            column: column,
          ),
    ];

    cells.shuffle(random);

    for (final cell in cells) {
      if (arrows.length >= arrowCount) {
        break;
      }

      final directions = List<ArrowDirection>.from(
        ArrowDirection.values,
      )..shuffle(random);

      for (final direction in directions) {
        final maxLength = _maxLength(
          cell,
          direction,
          size,
        );

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

        if (_canAddArrow(
          arrow,
          arrows,
          size,
        )) {
          arrows.add(arrow);
          break;
        }
      }
    }

    return LevelData(
      size: size,
      arrows: arrows,
    );
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

  bool _canAddArrow(
    Arrow arrow,
    List<Arrow> existing,
    int size,
  ) {
    final occupied = _occupiedCells(
      arrow,
      size,
    );

    if (occupied.isEmpty) {
      return false;
    }

    for (final other in existing) {
      final otherCells = _occupiedCells(
        other,
        size,
      );

      if (occupied.any(otherCells.contains)) {
        return false;
      }
    }

    return true;
  }

  Set<_Cell> _occupiedCells(
    Arrow arrow,
    int size,
  ) {
    final cells = <_Cell>{};

    var row = arrow.row;
    var column = arrow.column;

    if (!_insideBoard(row, column, size)) {
      return {};
    }

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

      if (!_insideBoard(row, column, size)) {
        return {};
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

  bool _insideBoard(
    int row,
    int column,
    int size,
  ) {
    return row >= 0 &&
        row < size &&
        column >= 0 &&
        column < size;
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
    return Object.hash(row, column);
  }
}