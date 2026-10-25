import 'package:flutter_test/flutter_test.dart';

import 'package:arrow_puzzle/game/arrow.dart';
import 'package:arrow_puzzle/game/generator/placement/reverse_solution_validator.dart';

void main() {
  const validator = ReverseSolutionValidator();

  test(
    'empty level with empty solution should be valid',
    () {
      expect(
        validator.isValid(
          arrows: const [],
          solutionOrder: const [],
          boardSize: 7,
        ),
        isTrue,
      );
    },
  );

  test(
    'single arrow with clear exit should be valid',
    () {
      const arrow = Arrow(
        row: 3,
        column: 3,
        direction: ArrowDirection.up,
        length: 1,
      );

      expect(
        validator.isValid(
          arrows: [
            arrow,
          ],
          solutionOrder: [
            arrow,
          ],
          boardSize: 7,
        ),
        isTrue,
      );
    },
  );

  test(
    'blocked arrow should require the blocker to be removed first',
    () {
      const blocked = Arrow(
        row: 3,
        column: 1,
        direction: ArrowDirection.right,
        length: 1,
      );

      const blocker = Arrow(
        row: 3,
        column: 2,
        direction: ArrowDirection.up,
        length: 1,
      );

      expect(
        validator.isValid(
          arrows: [
            blocked,
            blocker,
          ],
          solutionOrder: [
            blocker,
            blocked,
          ],
          boardSize: 7,
        ),
        isTrue,
      );
    },
  );

  test(
    'wrong solution order should be rejected',
    () {
      const blocked = Arrow(
        row: 3,
        column: 1,
        direction: ArrowDirection.right,
        length: 1,
      );

      const blocker = Arrow(
        row: 3,
        column: 2,
        direction: ArrowDirection.up,
        length: 1,
      );

      expect(
        validator.isValid(
          arrows: [
            blocked,
            blocker,
          ],
          solutionOrder: [
            blocked,
            blocker,
          ],
          boardSize: 7,
        ),
        isFalse,
      );
    },
  );

  test(
    'solution containing an unknown arrow should be rejected',
    () {
      const first = Arrow(
        row: 0,
        column: 0,
        direction: ArrowDirection.right,
        length: 1,
      );

      const unknown = Arrow(
        row: 5,
        column: 5,
        direction: ArrowDirection.left,
        length: 1,
      );

      expect(
        validator.isValid(
          arrows: [
            first,
          ],
          solutionOrder: [
            unknown,
          ],
          boardSize: 7,
        ),
        isFalse,
      );
    },
  );

  test(
    'solution with missing arrows should be rejected',
    () {
      const first = Arrow(
        row: 0,
        column: 0,
        direction: ArrowDirection.right,
        length: 1,
      );

      const second = Arrow(
        row: 5,
        column: 5,
        direction: ArrowDirection.left,
        length: 1,
      );

      expect(
        validator.isValid(
          arrows: [
            first,
            second,
          ],
          solutionOrder: [
            first,
          ],
          boardSize: 7,
        ),
        isFalse,
      );
    },
  );

  test(
    'solution with duplicate arrow should be rejected',
    () {
      const arrow = Arrow(
        row: 3,
        column: 3,
        direction: ArrowDirection.up,
        length: 1,
      );

      expect(
        validator.isValid(
          arrows: [
            arrow,
          ],
          solutionOrder: [
            arrow,
            arrow,
          ],
          boardSize: 7,
        ),
        isFalse,
      );
    },
  );

  test(
    'arrow leaving the board should be valid when no blocker exists',
    () {
      const arrow = Arrow(
        row: 0,
        column: 3,
        direction: ArrowDirection.up,
        length: 1,
      );

      expect(
        validator.isValid(
          arrows: [
            arrow,
          ],
          solutionOrder: [
            arrow,
          ],
          boardSize: 7,
        ),
        isTrue,
      );
    },
  );
}