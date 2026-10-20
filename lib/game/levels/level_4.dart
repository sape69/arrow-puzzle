import '../arrow.dart';
import '../level_data.dart';

const level4 = LevelData(
  size: 8,
  arrows: [
    Arrow(
      row: 6,
      column: 2,
      direction: ArrowDirection.down,
    ),
    Arrow.bent(
      row: 0,
      column: 7,
      direction: ArrowDirection.down,
      path: [
        ArrowDirection.down,
        ArrowDirection.left,
        ArrowDirection.down,
        ArrowDirection.right,
      ],
    ),
    Arrow(
      row: 5,
      column: 4,
      direction: ArrowDirection.down,
      length: 2,
    ),
    Arrow.bent(
      row: 7,
      column: 6,
      direction: ArrowDirection.right,
      path: [
        ArrowDirection.right,
        ArrowDirection.up,
        ArrowDirection.left,
      ],
    ),
    Arrow(
      row: 3,
      column: 2,
      direction: ArrowDirection.up,
    ),
    Arrow.bent(
      row: 1,
      column: 3,
      direction: ArrowDirection.right,
      path: [
        ArrowDirection.right,
        ArrowDirection.up,
        ArrowDirection.right,
        ArrowDirection.down,
      ],
    ),
    Arrow.bent(
      row: 3,
      column: 6,
      direction: ArrowDirection.right,
      path: [
        ArrowDirection.right,
        ArrowDirection.down,
        ArrowDirection.down,
      ],
    ),
    Arrow(
      row: 5,
      column: 5,
      direction: ArrowDirection.right,
    ),
    Arrow(
      row: 4,
      column: 4,
      direction: ArrowDirection.left,
      length: 2,
    ),
    Arrow.bent(
      row: 2,
      column: 1,
      direction: ArrowDirection.left,
      path: [
        ArrowDirection.left,
        ArrowDirection.up,
        ArrowDirection.right,
      ],
    ),
    Arrow(
      row: 0,
      column: 0,
      direction: ArrowDirection.left,
    ),
    Arrow(
      row: 7,
      column: 0,
      direction: ArrowDirection.left,
    ),
  ],
);