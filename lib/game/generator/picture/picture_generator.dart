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
      var segmentIndex = 0;

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

        final runLength = column - startColumn;

        var segmentStart = startColumn;
        var remaining = runLength;

        while (remaining > 0) {
          final length = remaining >= 2 ? 2 : 1;

          final pointsRight = segmentIndex.isEven;

          if (pointsRight) {
            arrows.add(
              Arrow(
                row: row,
                column: segmentStart,
                direction: ArrowDirection.right,
                length: length,
              ),
            );
          } else {
            arrows.add(
              Arrow(
                row: row,
                column: segmentStart + length - 1,
                direction: ArrowDirection.left,
                length: length,
              ),
            );
          }

          segmentStart += length;
          remaining -= length;
          segmentIndex++;
        }
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