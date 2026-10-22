import '../arrow.dart';
import '../level_data.dart';

const level7 = LevelData(
  size: 9,
  arrows: [
    Arrow(
      row: 0,
      column: 1,
      direction: ArrowDirection.right,
      length: 4,
    ),
    Arrow(
      row: 0,
      column: 6,
      direction: ArrowDirection.down,
      length: 3,
    ),
    Arrow(
      row: 1,
      column: 0,
      direction: ArrowDirection.down,
      length: 4,
    ),
    Arrow(
      row: 1,
      column: 4,
      direction: ArrowDirection.right,
      length: 3,
    ),
    Arrow(
      row: 1,
      column: 8,
      direction: ArrowDirection.down,
      length: 4,
    ),
    Arrow(
      row: 2,
      column: 2,
      direction: ArrowDirection.left,
      length: 3,
    ),
    Arrow(
      row: 2,
      column: 5,
      direction: ArrowDirection.down,
      length: 3,
    ),
    Arrow(
      row: 3,
      column: 1,
      direction: ArrowDirection.right,
      length: 4,
    ),
    Arrow(
      row: 3,
      column: 7,
      direction: ArrowDirection.left,
      length: 3,
    ),
    Arrow.bent(
      row: 3,
      column: 4,
      direction: ArrowDirection.down,
      path: [
        ArrowDirection.down,
        ArrowDirection.down,
        ArrowDirection.left,
        ArrowDirection.left,
      ],
    ),
    Arrow(
      row: 4,
      column: 0,
      direction: ArrowDirection.right,
      length: 3,
    ),
    Arrow(
      row: 4,
      column: 6,
      direction: ArrowDirection.down,
      length: 3,
    ),
    Arrow(
      row: 5,
      column: 2,
      direction: ArrowDirection.right,
      length: 3,
    ),
    Arrow(
      row: 5,
      column: 8,
      direction: ArrowDirection.left,
      length: 4,
    ),
    Arrow.bent(
      row: 5,
      column: 5,
      direction: ArrowDirection.down,
      path: [
        ArrowDirection.down,
        ArrowDirection.left,
        ArrowDirection.left,
        ArrowDirection.up,
      ],
    ),
    Arrow(
      row: 6,
      column: 0,
      direction: ArrowDirection.up,
      length: 3,
    ),
    Arrow(
      row: 6,
      column: 4,
      direction: ArrowDirection.right,
      length: 3,
    ),
    Arrow(
      row: 7,
      column: 1,
      direction: ArrowDirection.down,
      length: 2,
    ),
    Arrow(
      row: 7,
      column: 6,
      direction: ArrowDirection.right,
      length: 3,
    ),
    Arrow(
      row: 8,
      column: 0,
      direction: ArrowDirection.right,
      length: 5,
    ),
    Arrow(
      row: 8,
      column: 6,
      direction: ArrowDirection.up,
      length: 4,
    ),
    Arrow.bent(
      row: 7,
      column: 4,
      direction: ArrowDirection.up,
      path: [
        ArrowDirection.up,
        ArrowDirection.left,
        ArrowDirection.left,
        ArrowDirection.down,
      ],
    ),
  ],
);