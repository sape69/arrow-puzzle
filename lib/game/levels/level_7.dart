import '../arrow.dart';
import '../level_data.dart';

const level7 = LevelData(
  size: 9,
  arrows: [
    Arrow(
      row: 0,
      column: 0,
      direction: ArrowDirection.up,
    ),
    Arrow(
      row: 0,
      column: 2,
      direction: ArrowDirection.up,
    ),
    Arrow(
      row: 0,
      column: 4,
      direction: ArrowDirection.up,
    ),
    Arrow(
      row: 0,
      column: 6,
      direction: ArrowDirection.up,
    ),
    Arrow(
      row: 0,
      column: 8,
      direction: ArrowDirection.right,
    ),
    Arrow(
      row: 1,
      column: 0,
      direction: ArrowDirection.left,
    ),
    Arrow(
      row: 2,
      column: 0,
      direction: ArrowDirection.left,
    ),
    Arrow(
      row: 3,
      column: 0,
      direction: ArrowDirection.left,
    ),
    Arrow(
      row: 4,
      column: 0,
      direction: ArrowDirection.left,
    ),
    Arrow(
      row: 8,
      column: 0,
      direction: ArrowDirection.left,
    ),
    Arrow(
      row: 8,
      column: 2,
      direction: ArrowDirection.down,
    ),
    Arrow(
      row: 8,
      column: 4,
      direction: ArrowDirection.down,
    ),
    Arrow(
      row: 8,
      column: 6,
      direction: ArrowDirection.down,
    ),
    Arrow(
      row: 8,
      column: 8,
      direction: ArrowDirection.down,
    ),
    Arrow(
      row: 7,
      column: 8,
      direction: ArrowDirection.right,
    ),
    Arrow(
      row: 6,
      column: 8,
      direction: ArrowDirection.right,
    ),
    Arrow(
      row: 5,
      column: 8,
      direction: ArrowDirection.right,
    ),
    Arrow(
      row: 4,
      column: 8,
      direction: ArrowDirection.right,
    ),
    Arrow(
      row: 2,
      column: 4,
      direction: ArrowDirection.up,
      length: 2,
    ),
    Arrow(
      row: 5,
      column: 4,
      direction: ArrowDirection.down,
      length: 2,
    ),
  ],
);