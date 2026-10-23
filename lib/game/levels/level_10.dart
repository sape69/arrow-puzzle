import '../generator/picture/picture_generator.dart';
import '../generator/picture/picture_definition.dart';
import '../level_data.dart';

const _pictureGenerator = PictureGenerator();

final LevelData level10 = _pictureGenerator.generate(
  stellaCatPicture,
);