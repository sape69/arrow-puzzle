import '../../arrow.dart';
import '../../level_data.dart';

import 'picture_arrow_definition.dart';

class PictureArrowGenerator {
  const PictureArrowGenerator();

  LevelData generate({
    required int boardSize,
    required List<PictureArrowDefinition> definitions,
  }) {
    final arrows = <Arrow>[];

    for (final definition in definitions) {
      if (definition.path.isEmpty) {
        continue;
      }

      arrows.add(
        Arrow.bent(
          row: definition.row,
          column: definition.column,
          direction: definition.path.first,
          path: definition.path,
        ),
      );
    }

    return LevelData(
      size: boardSize,
      arrows: arrows,
    );
  }
}