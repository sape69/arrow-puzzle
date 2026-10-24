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

  test(
    'same seed should produce the same level',
    () {
      final first = generator.generate(
        size: 10,
        arrowCount: 20,
        random: Random(123),
      );

      final second = generator.generate(
        size: 10,
        arrowCount: 20,
        random: Random(123),
      );

      expect(
        _levelSignature(first),
        _levelSignature(second),
      );
    },
  );

  test(
    'different seeds should normally produce different levels',
    () {
      final first = generator.generate(
        size: 10,
        arrowCount: 20,
        random: Random(123),
      );

      final second = generator.generate(
        size: 10,
        arrowCount: 20,
        random: Random(456),
      );

      expect(
        _levelSignature(first),
        isNot(
          equals(
            _levelSignature(second),
          ),
        ),
      );
    },
  );
}

String _levelSignature(
  dynamic level,
) {
  final arrows = List.of(level.arrows);

  arrows.sort(
    (first, second) {
      final rowCompare =
          first.row.compareTo(second.row);

      if (rowCompare != 0) {
        return rowCompare;
      }

      final columnCompare =
          first.column.compareTo(second.column);

      if (columnCompare != 0) {
        return columnCompare;
      }

      final directionCompare =
          first.direction.index.compareTo(
        second.direction.index,
      );

      if (directionCompare != 0) {
        return directionCompare;
      }

      return first.length.compareTo(
        second.length,
      );
    },
  );

  return arrows
      .map(
        (arrow) => [
          arrow.row,
          arrow.column,
          arrow.direction.name,
          arrow.length,
        ].join(':'),
      )
      .join('|');
}