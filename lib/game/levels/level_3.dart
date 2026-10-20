import '../arrow.dart';
import '../level_data.dart';

const level3 = LevelData(
  arrows: [
    // Ulompi kerros
    Arrow(row: 0, column: 1, direction: ArrowDirection.up),
    Arrow(row: 0, column: 3, direction: ArrowDirection.up),
    Arrow(row: 0, column: 5, direction: ArrowDirection.up),

    Arrow(row: 6, column: 1, direction: ArrowDirection.down),
    Arrow(row: 6, column: 3, direction: ArrowDirection.down),
    Arrow(row: 6, column: 5, direction: ArrowDirection.down),

    Arrow(row: 1, column: 0, direction: ArrowDirection.left),
    Arrow(row: 3, column: 0, direction: ArrowDirection.left),
    Arrow(row: 5, column: 0, direction: ArrowDirection.left),

    Arrow(row: 1, column: 6, direction: ArrowDirection.right),
    Arrow(row: 3, column: 6, direction: ArrowDirection.right),
    Arrow(row: 5, column: 6, direction: ArrowDirection.right),

    // Sisempi kerros
    Arrow(row: 2, column: 2, direction: ArrowDirection.left),
    Arrow(row: 2, column: 4, direction: ArrowDirection.right),
    Arrow(row: 3, column: 2, direction: ArrowDirection.up),
    Arrow(row: 3, column: 4, direction: ArrowDirection.down),
    Arrow(row: 4, column: 2, direction: ArrowDirection.left),
    Arrow(row: 4, column: 4, direction: ArrowDirection.right),
  ],
);