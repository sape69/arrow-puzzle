import '../arrow.dart';
import '../level_data.dart';

const level6 = LevelData(
  size: 9,
  arrows: [
    Arrow(
      row: 0,
      column: 0,
      direction: ArrowDirection.right,
      length: 4,
    ),

    Arrow(
      row: 0,
      column: 5,
      direction: ArrowDirection.right,
      length: 4,
    ),

    Arrow(
      row: 1,
      column: 0,
      direction: ArrowDirection.down,
      length: 4,
    ),

    Arrow(
      row: 2,
      column: 8,
      direction: ArrowDirection.down,
      length: 4,
    ),

    Arrow(
      row: 8,
      column: 0,
      direction: ArrowDirection.right,
      length: 5,
    ),

    Arrow(
      row: 8,
      column: 7,
      direction: ArrowDirection.up,
      length: 4,
    ),

    Arrow(
      row: 6,
      column: 0,
      direction: ArrowDirection.right,
      length: 3,
    ),

    Arrow(
      row: 7,
      column: 3,
      direction: ArrowDirection.right,
      length: 4,
    ),

    Arrow.bent(
      row: 1,
      column: 3,
      direction: ArrowDirection.down,
      path: [
        ArrowDirection.down,
        ArrowDirection.down,
        ArrowDirection.right,
        ArrowDirection.right,
      ],
    ),

    Arrow.bent(
      row: 1,
      column: 7,
      direction: ArrowDirection.down,
      path: [
        ArrowDirection.down,
        ArrowDirection.down,
        ArrowDirection.left,
        ArrowDirection.up,
      ],
    ),

    Arrow(
      row: 4,
      column: 1,
      direction: ArrowDirection.right,
      length: 3,
    ),

    Arrow(
      row: 5,
      column: 6,
      direction: ArrowDirection.left,
      length: 2,
    ),
  ],
);