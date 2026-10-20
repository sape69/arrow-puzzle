import '../arrow.dart';
import '../level_data.dart';

const level5 = LevelData(
  size: 8,
  arrows: [
    Arrow(
      row: 0,
      column: 0,
      direction: ArrowDirection.right,
      length: 3,
    ),

    Arrow(
      row: 0,
      column: 5,
      direction: ArrowDirection.down,
      length: 2,
    ),

    Arrow(
      row: 2,
      column: 0,
      direction: ArrowDirection.down,
      length: 3,
    ),

    Arrow(
      row: 6,
      column: 0,
      direction: ArrowDirection.right,
      length: 2,
    ),

    Arrow(
      row: 3,
      column: 2,
      direction: ArrowDirection.right,
      length: 3,
    ),

    Arrow.bent(
      row: 1,
      column: 3,
      direction: ArrowDirection.right,
      path: [
        ArrowDirection.right,
        ArrowDirection.down,
        ArrowDirection.right,
        ArrowDirection.right,
      ],
    ),

    Arrow.bent(
      row: 3,
      column: 7,
      direction: ArrowDirection.left,
      path: [
        ArrowDirection.left,
        ArrowDirection.left,
        ArrowDirection.down,
        ArrowDirection.down,
      ],
    ),

    Arrow.bent(
      row: 5,
      column: 4,
      direction: ArrowDirection.up,
      path: [
        ArrowDirection.up,
        ArrowDirection.left,
        ArrowDirection.left,
        ArrowDirection.down,
      ],
    ),

    Arrow(
      row: 7,
      column: 2,
      direction: ArrowDirection.right,
      length: 3,
    ),

    Arrow(
      row: 6,
      column: 7,
      direction: ArrowDirection.up,
      length: 3,
    ),

    Arrow(
      row: 7,
      column: 6,
      direction: ArrowDirection.up,
      length: 2,
    ),

    Arrow(
      row: 5,
      column: 0,
      direction: ArrowDirection.right,
      length: 2,
    ),
  ],
);