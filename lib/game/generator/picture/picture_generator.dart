import '../../arrow.dart';
import '../../level_data.dart';

import 'picture_definition.dart';

class PictureGenerator {
  const PictureGenerator();

  LevelData generate(
    PictureDefinition picture,
  ) {
    final arrows = <Arrow>[];

    for (var row = 0; row < picture.height; row++) {
      for (var column = 0; column < picture.width; column++) {
        final direction = picture.directionAt(
          row,
          column,
        );

        if (direction == null) {
          continue;
        }

        if (!_isArrowStart(
          picture,
          row,
          column,
          direction,
        )) {
          continue;
        }

        final length = _runLength(
          picture,
          row,
          column,
          direction,
        );

        arrows.add(
          Arrow(
            row: row,
            column: column,
            direction: direction,
            length: length,
          ),
        );
      }
    }

    return LevelData(
      size: _boardSize(picture),
      arrows: arrows,
    );
  }

  bool _isArrowStart(
    PictureDefinition picture,
    int row,
    int column,
    ArrowDirection direction,
  ) {
    final previous = _move(
      row,
      column,
      _opposite(direction),
    );

    return picture.directionAt(
          previous.row,
          previous.column,
        ) !=
        direction;
  }

  int _runLength(
    PictureDefinition picture,
    int row,
    int column,
    ArrowDirection direction,
  ) {
    var length = 1;

    var current = _move(
      row,
      column,
      direction,
    );

    while (picture.directionAt(
          current.row,
          current.column,
        ) ==
        direction) {
      length++;

      current = _move(
        current.row,
        current.column,
        direction,
      );
    }

    return length;
  }

  ArrowDirection _opposite(
    ArrowDirection direction,
  ) {
    switch (direction) {
      case ArrowDirection.up:
        return ArrowDirection.down;

      case ArrowDirection.right:
        return ArrowDirection.left;

      case ArrowDirection.down:
        return ArrowDirection.up;

      case ArrowDirection.left:
        return ArrowDirection.right;
    }
  }

  _Position _move(
    int row,
    int column,
    ArrowDirection direction,
  ) {
    switch (direction) {
      case ArrowDirection.up:
        return _Position(
          row: row - 1,
          column: column,
        );

      case ArrowDirection.right:
        return _Position(
          row: row,
          column: column + 1,
        );

      case ArrowDirection.down:
        return _Position(
          row: row + 1,
          column: column,
        );

      case ArrowDirection.left:
        return _Position(
          row: row,
          column: column - 1,
        );
    }
  }

  int _boardSize(
    PictureDefinition picture,
  ) {
    return picture.height > picture.width
        ? picture.height
        : picture.width;
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