import 'package:flutter_test/flutter_test.dart';

import 'package:arrow_puzzle/game/arrow.dart';
import 'package:arrow_puzzle/game/generator/picture/picture_definition.dart';
import 'package:arrow_puzzle/game/generator/picture/picture_generator.dart';

void main() {
  test(
    'Stella picture should generate arrows',
    () {
      const generator = PictureGenerator();

      final level = generator.generate(
        stellaCatPicture,
      );

      expect(
        level.size,
        11,
      );

      expect(
        level.arrows,
        isNotEmpty,
      );

      for (final arrow in level.arrows) {
        expect(
          arrow.direction,
          ArrowDirection.right,
        );

        expect(
          arrow.length,
          greaterThan(0),
        );
      }
    },
  );
}