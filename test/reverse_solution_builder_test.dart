import 'package:flutter_test/flutter_test.dart';

import 'package:arrow_puzzle/game/arrow.dart';
import 'package:arrow_puzzle/game/generator/placement/reverse_solution_builder.dart';

void main() {
  const builder = ReverseSolutionBuilder();

  test(
    'empty arrow list should produce an empty solution',
    () {
      final solution = builder.build(
        const [],
      );

      expect(
        solution,
        isEmpty,
      );
    },
  );

  test(
    'single arrow should be the only solution step',
    () {
      const arrow = Arrow(
        row: 3,
        column: 3,
        direction: ArrowDirection.up,
        length: 1,
      );

      final solution = builder.build(
        [
          arrow,
        ],
      );

      expect(
        solution,
        [
          arrow,
        ],
      );
    },
  );

  test(
    'arrows that can exit should be returned in removable order',
    () {
      const first = Arrow(
        row: 0,
        column: 0,
        direction: ArrowDirection.up,
        length: 1,
      );

      const second = Arrow(
        row: 2,
        column: 2,
        direction: ArrowDirection.right,
        length: 1,
      );

      final solution = builder.build(
        [
          first,
          second,
        ],
      );

      expect(
        solution.length,
        2,
      );

      expect(
        solution[0],
        first,
      );

      expect(
        solution[1],
        second,
      );
    },
  );

  test(
    'blocked arrow should become removable after blocker is removed',
    () {
      const blocker = Arrow(
        row: 0,
        column: 1,
        direction: ArrowDirection.up,
        length: 1,
      );

      const blocked = Arrow(
        row: 0,
        column: 0,
        direction: ArrowDirection.right,
        length: 1,
      );

      final solution = builder.build(
        [
          blocked,
          blocker,
        ],
      );

      expect(
        solution.length,
        2,
      );

      expect(
        solution[0],
        blocker,
      );

      expect(
        solution[1],
        blocked,
      );
    },
  );

  test(
    'solution should contain every arrow exactly once',
    () {
      const first = Arrow(
        row: 0,
        column: 0,
        direction: ArrowDirection.up,
        length: 1,
      );

      const second = Arrow(
        row: 2,
        column: 2,
        direction: ArrowDirection.down,
        length: 1,
      );

      const third = Arrow(
        row: 4,
        column: 4,
        direction: ArrowDirection.left,
        length: 1,
      );

      final solution = builder.build(
        [
          first,
          second,
          third,
        ],
      );

      expect(
        solution.length,
        3,
      );

      expect(
        solution.toSet().length,
        3,
      );

      expect(
        solution.toSet(),
        {
          first,
          second,
          third,
        },
      );
    },
  );
}