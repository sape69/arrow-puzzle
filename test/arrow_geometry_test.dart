import 'package:flutter_test/flutter_test.dart';

import 'package:arrow_puzzle/game/arrow.dart';
import 'package:arrow_puzzle/game/generator/geometry/arrow_geometry.dart';

void main() {
  const geometry = ArrowGeometry();

  test(
    'straight arrow should return all occupied cells',
    () {
      const arrow = Arrow(
        row: 2,
        column: 1,
        direction: ArrowDirection.right,
        length: 4,
      );

      final cells = geometry.cells(arrow);

      expect(
        cells,
        [
          const GridCell(
            row: 2,
            column: 1,
          ),
          const GridCell(
            row: 2,
            column: 2,
          ),
          const GridCell(
            row: 2,
            column: 3,
          ),
          const GridCell(
            row: 2,
            column: 4,
          ),
        ],
      );
    },
  );

  test(
    'bent arrow should follow its complete path',
    () {
      const arrow = Arrow.bent(
        row: 2,
        column: 2,
        direction: ArrowDirection.right,
        path: [
          ArrowDirection.right,
          ArrowDirection.down,
          ArrowDirection.down,
          ArrowDirection.left,
        ],
      );

      final cells = geometry.cells(arrow);

      expect(
        cells,
        [
          const GridCell(
            row: 2,
            column: 2,
          ),
          const GridCell(
            row: 2,
            column: 3,
          ),
          const GridCell(
            row: 3,
            column: 3,
          ),
          const GridCell(
            row: 4,
            column: 3,
          ),
          const GridCell(
            row: 4,
            column: 2,
          ),
        ],
      );
    },
  );

  test(
    'tip should be the final cell of the arrow path',
    () {
      const arrow = Arrow.bent(
        row: 1,
        column: 1,
        direction: ArrowDirection.right,
        path: [
          ArrowDirection.right,
          ArrowDirection.down,
          ArrowDirection.right,
        ],
      );

      expect(
        geometry.tip(arrow),
        const GridCell(
          row: 2,
          column: 3,
        ),
      );
    },
  );

  test(
    'arrow should be inside the board when every cell is inside',
    () {
      const arrow = Arrow(
        row: 2,
        column: 2,
        direction: ArrowDirection.down,
        length: 3,
      );

      expect(
        geometry.isInsideBoard(
          arrow,
          7,
        ),
        isTrue,
      );
    },
  );

  test(
    'arrow should be outside the board when its path leaves the board',
    () {
      const arrow = Arrow(
        row: 5,
        column: 2,
        direction: ArrowDirection.down,
        length: 3,
      );

      expect(
        geometry.isInsideBoard(
          arrow,
          7,
        ),
        isFalse,
      );
    },
  );

  test(
    'self-intersecting bent arrow should be detected',
    () {
      const arrow = Arrow.bent(
        row: 2,
        column: 2,
        direction: ArrowDirection.right,
        path: [
          ArrowDirection.right,
          ArrowDirection.down,
          ArrowDirection.left,
          ArrowDirection.up,
        ],
      );

      expect(
        geometry.isSelfIntersecting(arrow),
        isTrue,
      );
    },
  );

  test(
    'valid bent arrow should not self-intersect',
    () {
      const arrow = Arrow.bent(
        row: 1,
        column: 1,
        direction: ArrowDirection.right,
        path: [
          ArrowDirection.right,
          ArrowDirection.down,
          ArrowDirection.right,
        ],
      );

      expect(
        geometry.isSelfIntersecting(arrow),
        isFalse,
      );
    },
  );

  test(
    'valid arrow path should be accepted',
    () {
      const arrow = Arrow(
        row: 1,
        column: 1,
        direction: ArrowDirection.right,
        length: 3,
      );

      expect(
        geometry.isValidPath(
          arrow,
          7,
        ),
        isTrue,
      );
    },
  );

  test(
    'invalid bent arrow leaving board should be rejected',
    () {
      const arrow = Arrow.bent(
        row: 0,
        column: 0,
        direction: ArrowDirection.left,
        path: [
          ArrowDirection.left,
          ArrowDirection.down,
        ],
      );

      expect(
        geometry.isValidPath(
          arrow,
          7,
        ),
        isFalse,
      );
    },
  );
}