import 'package:flutter_test/flutter_test.dart';

import 'package:arrow_puzzle/game/arrow.dart';
import 'package:arrow_puzzle/game/generator/placement/reverse_solution_builder.dart';

void main() {
  const builder = ReverseSolutionBuilder();

  const arrowA = Arrow(
    row: 0,
    column: 0,
    direction: ArrowDirection.right,
    length: 1,
  );

  const arrowB = Arrow(
    row: 2,
    column: 2,
    direction: ArrowDirection.left,
    length: 1,
  );

  const arrowC = Arrow(
    row: 4,
    column: 4,
    direction: ArrowDirection.up,
    length: 1,
  );

  test(
    'builder should return an empty plan for empty input',
    () {
      final plan = builder.build(
        const [],
        boardSize: 5,
      );

      expect(
        plan.isEmpty,
        isTrue,
      );

      expect(
        plan.length,
        0,
      );
    },
  );

  test(
    'builder should create a plan for a single arrow',
    () {
      final plan = builder.build(
        const [
          arrowA,
        ],
        boardSize: 5,
      );

      expect(
        plan.length,
        1,
      );

      expect(
        plan[0],
        arrowA,
      );
    },
  );

  test(
    'builder should include every arrow exactly once',
    () {
      final plan = builder.build(
        const [
          arrowA,
          arrowB,
          arrowC,
        ],
        boardSize: 5,
      );

      expect(
        plan.length,
        3,
      );

      expect(
        plan.orderedArrows.toSet(),
        equals({
          arrowA,
          arrowB,
          arrowC,
        }),
      );
    },
  );

  test(
    'builder should build a solution when arrows can leave independently',
    () {
      final plan = builder.build(
        const [
          arrowA,
          arrowB,
          arrowC,
        ],
        boardSize: 5,
      );

      expect(
        plan.isNotEmpty,
        isTrue,
      );

      expect(
        plan.length,
        3,
      );
    },
  );

  test(
    'builder should remove a blocking arrow before the blocked arrow',
    () {
      const blocker = Arrow(
        row: 2,
        column: 4,
        direction: ArrowDirection.right,
        length: 1,
      );

      const blocked = Arrow(
        row: 2,
        column: 2,
        direction: ArrowDirection.right,
        length: 1,
      );

      final plan = builder.build(
        const [
          blocked,
          blocker,
        ],
        boardSize: 5,
      );

      expect(
        plan.length,
        2,
      );

      expect(
        plan.indexOf(blocker),
        lessThan(
          plan.indexOf(blocked),
        ),
      );
    },
  );

  test(
    'builder should throw when no arrow can leave',
    () {
      const arrowOne = Arrow(
        row: 2,
        column: 1,
        direction: ArrowDirection.right,
        length: 1,
      );

      const arrowTwo = Arrow(
        row: 2,
        column: 2,
        direction: ArrowDirection.left,
        length: 1,
      );

      expect(
        () => builder.build(
          const [
            arrowOne,
            arrowTwo,
          ],
          boardSize: 5,
        ),
        throwsStateError,
      );
    },
  );

  test(
    'builder should infer board size when it is omitted',
    () {
      final plan = builder.build(
        const [
          arrowC,
        ],
      );

      expect(
        plan.length,
        1,
      );

      expect(
        plan[0],
        arrowC,
      );
    },
  );
}