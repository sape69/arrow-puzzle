import '../generator/picture/picture_arrow_definition.dart';
import '../generator/picture/picture_arrow_generator.dart';
import '../level_data.dart';

const _pictureArrowGenerator = PictureArrowGenerator();

final LevelData level10 = _pictureArrowGenerator.generate(
  boardSize: 11,
  definitions: stellaPictureArrows,
);