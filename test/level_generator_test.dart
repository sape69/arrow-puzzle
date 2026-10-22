import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:arrow_puzzle/game/game_board.dart';
import 'package:arrow_puzzle/game/level_generator.dart';
import 'package:arrow_puzzle/game/level_solver.dart';

void main() {
  test(
    'Level 7 generator creates a solvable 9x9 level',
    () {
      const generator = LevelGenerator();
      const solver = LevelSolver();

      final level = generator.generate(
        size: 9,
        arrowCount: 20,
        seed: 7,
        maxAttempts: 1000,
      );

      final board = GameBoard(
        level: level,
      );

      final solution = solver.findSolution(board);

      debugPrint('');
      debugPrint('=== GENERATED LEVEL 7 ===');
      debugPrint('size: ${level.size}');
      debugPrint('arrows: ${level.arrows.length}');
      debugPrint('');

      for (var i = 0;
          i < level.arrows.length;
          i++) {
        final arrow = level.arrows[i];

        debugPrint(
          'Arrow('
          'row: ${arrow.row}, '
          'column: ${arrow.column}, '
          'direction: ArrowDirection.${arrow.direction.name}, '
          'length: ${arrow.length},'
          '),',
        );
      }

      debugPrint('');
      debugPrint(
        'solution length: ${solution?.length ?? 0}',
      );
      debugPrint('==========================');
      debugPrint('');

      expect(
        level.size,
        9,
      );

      expect(
        level.arrows.length,
        20,
      );

      expect(
        solution,
        isNotNull,
      );

      expect(
        solution!.length,
        level.arrows.length,
      );
    },
  );
}