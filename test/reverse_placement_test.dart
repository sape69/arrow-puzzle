import 'package:flutter_test/flutter_test.dart';

import 'package:arrow_puzzle/game/arrow.dart';
import 'package:arrow_puzzle/game/generator/placement/reverse_placement.dart';

void main() {
  const placement = ReversePlacement();

  test(
    'valid arrow should be accepted',
    () {
      const arrow = Arrow(
        row: 0,
        column: 0,
        direction: ArrowDirection.right,
        length: 2,
      );

      expect(
        placement.canPlace(
          arrow,
          const [],
          7,
        ),
        isTrue,
      );
    },
  );

  test(
    'arrow leaving the board should be rejected',
    () {
      const arrow = Arrow(
        row: 6,
        column: 0,
        direction: ArrowDirection.down,
        length: 2,
      );

      expect(
        placement.canPlace(
          arrow,
          const [],
          7,
        ),
        isFalse,
      );
    },
  );

  test(
    'overlapping arrow should be rejected',
    () {
      const existing = Arrow(
        row: 2,
        column: 2,
        direction: ArrowDirection.right,
        length: 3,
      );

      const candidate = Arrow(
        row: 2,
        column: 4,
        direction: ArrowDirection.down,
        length: 2,
      );

      expect(
        placement.canPlace(
          candidate,
          [
            existing,
          ],
          7,
        ),
        isFalse,
      );
    },
  );

  test(
    'non-overlapping arrow should be accepted',
    () {
      const existing = Arrow(
        row: 2,
        column: 2,
        direction: ArrowDirection.right,
        length: 2,
      );

      const candidate = Arrow(
        row: 5,
        column: 5,
        direction: ArrowDirection.up,
        length: 2,
      );

      expect(
        placement.canPlace(
          candidate,
          [
            existing,
          ],
          7,
        ),
        isTrue,
      );
    },
  );

  test(
    'solution order should be preserved when arrows are independently removable',
    () {
      const first = Arrow(
        row: 0,
        column: 0,
        direction: ArrowDirection.up,
        length: 1,
      );

      const second = Arrow(
        row: 3,
        column: 3,
        direction: ArrowDirection.right,
        length: 1,
      );

      expect(
        placement.preservesSolutionOrder(
          second,
          [
            first,
          ],
          [
            first,
            second,
          ],
          7,
        ),
        isTrue,
      );
    },
  );

  test(
    'candidate should be rejected when it breaks placement rules',
    () {
      const existing = Arrow(
        row: 3,
        column: 3,
        direction: ArrowDirection.right,
        length: 2,
      );

      const candidate = Arrow(
        row: 3,
        column: 4,
        direction: ArrowDirection.left,
        length: 1,
      );

      expect(
        placement.preservesSolutionOrder(
          candidate,
          [
            existing,
          ],
          [
            existing,
            candidate,
          ],
          7,
        ),
        isFalse,
      );
    },
  );
}