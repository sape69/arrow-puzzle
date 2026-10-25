import 'package:flutter_test/flutter_test.dart';

import 'package:arrow_puzzle/game/arrow.dart';
import 'package:arrow_puzzle/game/generator/placement/reverse_solution_plan.dart';

void main() {
  const arrowA = Arrow(
    row: 0,
    column: 0,
    direction: ArrowDirection.right,
    length: 2,
  );

  const arrowB = Arrow(
    row: 2,
    column: 3,
    direction: ArrowDirection.down,
    length: 1,
  );

  const arrowC = Arrow(
    row: 4,
    column: 4,
    direction: ArrowDirection.left,
    length: 3,
  );

  test(
    'plan should preserve solution order',
    () {
      const plan = ReverseSolutionPlan(
        arrows: [
          arrowA,
          arrowB,
          arrowC,
        ],
      );

      expect(plan.length, 3);
      expect(plan[0], arrowA);
      expect(plan[1], arrowB);
      expect(plan[2], arrowC);
    },
  );

  test(
    'plan should report whether it is empty',
    () {
      const emptyPlan = ReverseSolutionPlan(
        arrows: [],
      );

      const nonEmptyPlan = ReverseSolutionPlan(
        arrows: [
          arrowA,
        ],
      );

      expect(emptyPlan.isEmpty, isTrue);
      expect(emptyPlan.isNotEmpty, isFalse);

      expect(nonEmptyPlan.isEmpty, isFalse);
      expect(nonEmptyPlan.isNotEmpty, isTrue);
    },
  );

  test(
    'plan should find arrows',
    () {
      const plan = ReverseSolutionPlan(
        arrows: [
          arrowA,
          arrowB,
          arrowC,
        ],
      );

      expect(
        plan.contains(arrowA),
        isTrue,
      );

      expect(
        plan.contains(arrowB),
        isTrue,
      );

      expect(
        plan.contains(arrowC),
        isTrue,
      );

      expect(
        plan.indexOf(arrowA),
        0,
      );

      expect(
        plan.indexOf(arrowB),
        1,
      );

      expect(
        plan.indexOf(arrowC),
        2,
      );
    },
  );

  test(
    'plan should return -1 for an unknown arrow',
    () {
      const plan = ReverseSolutionPlan(
        arrows: [
          arrowA,
          arrowB,
        ],
      );

      const unknownArrow = Arrow(
        row: 5,
        column: 5,
        direction: ArrowDirection.up,
        length: 1,
      );

      expect(
        plan.contains(unknownArrow),
        isFalse,
      );

      expect(
        plan.indexOf(unknownArrow),
        -1,
      );
    },
  );

  test(
    'orderedArrows should expose the solution order',
    () {
      const plan = ReverseSolutionPlan(
        arrows: [
          arrowA,
          arrowB,
          arrowC,
        ],
      );

      expect(
        plan.orderedArrows,
        equals([
          arrowA,
          arrowB,
          arrowC,
        ]),
      );
    },
  );

  test(
    'copy should preserve the complete plan',
    () {
      const plan = ReverseSolutionPlan(
        arrows: [
          arrowA,
          arrowB,
          arrowC,
        ],
      );

      final copy = plan.copy();

      expect(
        copy,
        equals(plan),
      );

      expect(
        copy.arrows,
        equals(plan.arrows),
      );
    },
  );

  test(
    'equal plans should have the same hash code',
    () {
      const first = ReverseSolutionPlan(
        arrows: [
          arrowA,
          arrowB,
        ],
      );

      const second = ReverseSolutionPlan(
        arrows: [
          arrowA,
          arrowB,
        ],
      );

      expect(
        first,
        equals(second),
      );

      expect(
        first.hashCode,
        equals(second.hashCode),
      );
    },
  );

  test(
    'different solution orders should not be equal',
    () {
      const first = ReverseSolutionPlan(
        arrows: [
          arrowA,
          arrowB,
        ],
      );

      const second = ReverseSolutionPlan(
        arrows: [
          arrowB,
          arrowA,
        ],
      );

      expect(
        first,
        isNot(equals(second)),
      );
    },
  );
}