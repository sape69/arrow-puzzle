import '../arrow.dart';
import '../level_data.dart';

const level2 = LevelData(
  arrows: [
    Arrow(row: 2, column: 4, direction: ArrowDirection.up),
    Arrow(row: 0, column: 5, direction: ArrowDirection.right),
    Arrow(row: 0, column: 1, direction: ArrowDirection.right),
    Arrow(row: 5, column: 2, direction: ArrowDirection.left),
    Arrow(row: 2, column: 5, direction: ArrowDirection.left),
    Arrow(row: 3, column: 6, direction: ArrowDirection.up),
    Arrow(row: 3, column: 3, direction: ArrowDirection.left),
    Arrow(row: 4, column: 5, direction: ArrowDirection.down),
    Arrow(row: 3, column: 1, direction: ArrowDirection.up),
    Arrow(row: 1, column: 1, direction: ArrowDirection.right),
    Arrow(row: 1, column: 5, direction: ArrowDirection.up),
    Arrow(row: 2, column: 3, direction: ArrowDirection.down),
    Arrow(row: 4, column: 0, direction: ArrowDirection.down),
    Arrow(row: 0, column: 0, direction: ArrowDirection.right),
    Arrow(row: 2, column: 0, direction: ArrowDirection.down),
    Arrow(row: 4, column: 1, direction: ArrowDirection.right),
  ],
);