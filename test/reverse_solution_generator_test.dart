import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:arrow_puzzle/game/game_board.dart';
import 'package:arrow_puzzle/game/generator/placement/reverse_solution_generator.dart';
import 'package:arrow_puzzle/game/generator/placement/reverse_solution_order.dart';
import 'package:arrow_puzzle/game/generator/placement/reverse_solution_order_validator.dart';
import 'package:arrow_puzzle/game/generator/rules/placement_rules.dart';
import 'package:arrow_puzzle/game/level_solver.dart';

void main() {
  const generator = ReverseSolutionGenerator();
  const rules = PlacementRules();
  const solver = LevelSolver();
  const orderValidator = ReverseSolutionOrderValidator();

  test(
    'generator should create a valid solvable level',
    () {
      final level = generator.generate(
        size: 10,
        arrowCount: 20,
        random: Random(12345),
      );

      expect(level.size, 10);
      expect(level.arrows.length, 20);

      expect(
        rules.canPlaceAll(level.arrows),
        isTrue,
      );

      final board = GameBoard(level: level);
      final solution = solver.findSolution(board);

      expect(solution, isNotNull);
    },
  );

  test(
    'generator should create a valid level on a small board',
    () {
      final level = generator.generate(
        size: 6,
        arrowCount: 10,
        random: Random(42),
      );

      expect(level.size, 6);
      expect(level.arrows.length, 10);

      expect(
        rules.canPlaceAll(level.arrows),
        isTrue,
      );

      expect(
        solver.findSolution(
          GameBoard(level: level),
        ),
        isNotNull,
      );
    },
  );

  test(
    'generator should create a valid level with many arrows',
    () {
      final level = generator.generate(
        size: 15,
        arrowCount: 40,
        random: Random(9876),
      );

      expect(level.size, 15);
      expect(level.arrows.length, 40);

      expect(
        rules.canPlaceAll(level.arrows),
        isTrue,
      );

      expect(
        solver.findSolution(
          GameBoard(level: level),
        ),
        isNotNull,
      );
    },
  );

  test(
    'generator should produce the same level for the same seed',
    () {
      final first = generator.generate(
        size: 10,
        arrowCount: 20,
        random: Random(12345),
      );

      final second = generator.generate(
        size: 10,
        arrowCount: 20,
        random: Random(12345),
      );

      expect(first.size, second.size);
      expect(first.arrows.length, second.arrows.length);

      for (var index = 0;
          index < first.arrows.length;
          index++) {
        final firstArrow = first.arrows[index];
        final secondArrow = second.arrows[index];

        expect(firstArrow.row, secondArrow.row);
        expect(firstArrow.column, secondArrow.column);
        expect(firstArrow.direction, secondArrow.direction);
        expect(firstArrow.length, secondArrow.length);
        expect(firstArrow.path, equals(secondArrow.path));
      }
    },
  );

  test(
    'generator should reject an invalid board size',
    () {
      expect(
        () => generator.generate(
          size: 0,
          arrowCount: 10,
          random: Random(1),
        ),
        throwsArgumentError,
      );
    },
  );

  test(
    'generator should reject an invalid arrow count',
    () {
      expect(
        () => generator.generate(
          size: 10,
          arrowCount: 0,
          random: Random(1),
        ),
        throwsArgumentError,
      );
    },
  );

  test(
    'generated arrows should have a valid solution order',
    () {
      const boardSize = 10;

      final level = generator.generate(
        size: boardSize,
        arrowCount: 20,
        random: Random(2026),
      );

      final order = ReverseSolutionOrder(
        arrows: level.arrows,
      );

      expect(
        orderValidator.isValid(
          arrows: level.arrows,
          order: order,
          boardSize: boardSize,
        ),
        isTrue,
      );
    },
  );
}