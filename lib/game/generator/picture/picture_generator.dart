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
      var column = 0;

      while (column < picture.width) {
        if (!picture.isFilled(row, column)) {
          column++;
          continue;
        }

        final startColumn = column;

        while (column < picture.width &&
            picture.isFilled(row, column)) {
          column++;
        }

        final length = column - startColumn;

        arrows.add(
          Arrow(
            row: row,
            column: startColumn,
            direction: ArrowDirection.right,
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

  int _boardSize(
    PictureDefinition picture,
  ) {
    return picture.height > picture.width
        ? picture.height
        : picture.width;
  }
}