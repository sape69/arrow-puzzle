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
        final arrow = Arrow(
          row: cell.row,
          column: cell.column,
          direction: direction,
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

  bool _canAddArrow(
    Arrow arrow,
    List<Arrow> existing,
    int size,
  ) {
    if (!_insideBoard(
      arrow.row,
      arrow.column,
      size,
    )) {
      return false;
    }

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

    if (!_insideBoard(
      row,
      column,
      size,
    )) {
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

      if (!_insideBoard(
        row,
        column,
        size,
      )) {
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
    return Object.hash(
      row,
      column,
    );
  }
}