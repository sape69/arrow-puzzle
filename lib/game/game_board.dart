import 'arrow.dart';

class GameBoard {
  GameBoard({
    this.size = 7,
  });

  final int size;

  final List<Arrow> arrows = [
    const Arrow(
      row: 1,
      column: 1,
      direction: ArrowDirection.up,
    ),
    const Arrow(
      row: 1,
      column: 2,
      direction: ArrowDirection.up,
    ),
    const Arrow(
      row: 1,
      column: 3,
      direction: ArrowDirection.up,
    ),
    const Arrow(
      row: 1,
      column: 4,
      direction: ArrowDirection.up,
    ),
    const Arrow(
      row: 2,
      column: 1,
      direction: ArrowDirection.left,
    ),
    const Arrow(
      row: 2,
      column: 3,
      direction: ArrowDirection.up,
    ),
    const Arrow(
      row: 2,
      column: 5,
      direction: ArrowDirection.right,
    ),
    const Arrow(
      row: 3,
      column: 1,
      direction: ArrowDirection.left,
    ),
    const Arrow(
      row: 3,
      column: 2,
      direction: ArrowDirection.down,
    ),
    const Arrow(
      row: 3,
      column: 3,
      direction: ArrowDirection.right,
    ),
    const Arrow(
      row: 3,
      column: 4,
      direction: ArrowDirection.down,
    ),
    const Arrow(
      row: 3,
      column: 5,
      direction: ArrowDirection.right,
    ),
  ];
}