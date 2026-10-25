import 'dart:math';

import '../../arrow.dart';

class ReverseArrowFactory {
  const ReverseArrowFactory();

  Arrow create({
    required int boardSize,
    required Random random,
    int maxLength = 3,
  }) {
    if (boardSize < 1) {
      throw ArgumentError(
        'Board size must be positive.',
      );
    }

    if (maxLength < 1) {
      throw ArgumentError(
        'Maximum arrow length must be positive.',
      );
    }

    final row = random.nextInt(
      boardSize,
    );

    final column = random.nextInt(
      boardSize,
    );

    final direction = ArrowDirection
        .values[random.nextInt(
      ArrowDirection.values.length,
    )];

    final availableLength = _availableLength(
      row: row,
      column: column,
      direction: direction,
      boardSize: boardSize,
    );

    final actualMaxLength = min(
      availableLength,
      maxLength,
    );

    final length = 1 +
        random.nextInt(
          actualMaxLength,
        );

    return Arrow(
      row: row,
      column: column,
      direction: direction,
      length: length,
    );
  }

  int _availableLength({
    required int row,
    required int column,
    required ArrowDirection direction,
    required int boardSize,
  }) {
    switch (direction) {
      case ArrowDirection.up:
        return row + 1;

      case ArrowDirection.right:
        return boardSize - column;

      case ArrowDirection.down:
        return boardSize - row;

      case ArrowDirection.left:
        return column + 1;
    }
  }
}