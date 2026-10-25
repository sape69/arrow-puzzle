import 'dart:math';

import '../../arrow.dart';

class ReverseArrowFactory {
  const ReverseArrowFactory();

  Arrow create({
    required int boardSize,
    required Random random,
    ArrowDirection? exitDirection,
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

    final direction = exitDirection ??
        ArrowDirection.values[
          random.nextInt(
            ArrowDirection.values.length,
          )
        ];

    final tip = _randomTipPosition(
      boardSize: boardSize,
      direction: direction,
      random: random,
    );

    final availableLength = _availableLength(
      row: tip.row,
      column: tip.column,
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

    final start = _startPosition(
      tip: tip,
      direction: direction,
      length: length,
    );

    return Arrow(
      row: start.row,
      column: start.column,
      direction: direction,
      length: length,
    );
  }

  _Position _randomTipPosition({
    required int boardSize,
    required ArrowDirection direction,
    required Random random,
  }) {
    switch (direction) {
      case ArrowDirection.up:
        return _Position(
          row: random.nextInt(boardSize),
          column: random.nextInt(boardSize),
        );

      case ArrowDirection.right:
        return _Position(
          row: random.nextInt(boardSize),
          column: random.nextInt(boardSize),
        );

      case ArrowDirection.down:
        return _Position(
          row: random.nextInt(boardSize),
          column: random.nextInt(boardSize),
        );

      case ArrowDirection.left:
        return _Position(
          row: random.nextInt(boardSize),
          column: random.nextInt(boardSize),
        );
    }
  }

  _Position _startPosition({
    required _Position tip,
    required ArrowDirection direction,
    required int length,
  }) {
    final offset = length - 1;

    switch (direction) {
      case ArrowDirection.up:
        return _Position(
          row: tip.row + offset,
          column: tip.column,
        );

      case ArrowDirection.right:
        return _Position(
          row: tip.row,
          column: tip.column - offset,
        );

      case ArrowDirection.down:
        return _Position(
          row: tip.row - offset,
          column: tip.column,
        );

      case ArrowDirection.left:
        return _Position(
          row: tip.row,
          column: tip.column + offset,
        );
    }
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

class _Position {
  const _Position({
    required this.row,
    required this.column,
  });

  final int row;
  final int column;
}