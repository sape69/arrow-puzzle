import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:arrow_puzzle/game/game_board.dart';
import 'package:arrow_puzzle/game/generator/geometry/arrow_geometry.dart';
import 'package:arrow_puzzle/game/generator/placement/reverse_generator.dart';
import 'package:arrow_puzzle/game/generator/rules/placement_rules.dart';
import 'package:arrow_puzzle/game/level_solver.dart';

void main() {
  const generator = ReverseGenerator();
  const geometry = ArrowGeometry();
  const rules = PlacementRules();
  const solver = LevelSolver();

  test(
    'reverse generator should create the requested number of arrows',
    () {
      final level = generator.generate(
        size: 10,
        arrowCount: 20,
        random: Random(1),
      );

      expect(
        level.size,
        10,
      );

      expect(
        level.arrows.length,
        20,
      );
    },
  );

  test(
    'reverse generator should not create overlapping arrows',
    () {
      final level = generator.generate(
        size: 10,
        arrowCount: 20,
        random: Random(2),
      );

      expect(
        rules.canPlaceAll(
          level.arrows,
        ),
        isTrue,
      );
    },
  );

  test(
    'reverse generator should keep every arrow inside the board',
    () {
      final level = generator.generate(
        size: 10,
        arrowCount: 20,
        random: Random(3),
      );

      for (final arrow in level.arrows) {
        expect(
          geometry.isValidPath(
            arrow,
            level.size,
          ),
          isTrue,
        );
      }
    },
  );

  test(
    'reverse generated level should be solvable',
    () {
      final level = generator.generate(
        size: 10,
        arrowCount: 20,
        random: Random(4),
      );

      final board = GameBoard(
        level: level,
      );

      final solution = solver.findSolution(
        board,
      );

      expect(
        solution,
        isNotNull,
        reason:
            'A generated level should be solvable.',
      );

      expect(
        solution!.length,
        20,
      );
    },
  );
}