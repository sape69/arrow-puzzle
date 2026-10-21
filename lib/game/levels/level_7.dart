import '../arrow.dart';
import '../level_data.dart';

const level7 = LevelData(
  size: 7,
  arrows: [
    // Suoraan ylös ulos.
    Arrow(
      row: 3,
      column: 1,
      direction: ArrowDirection.up,
    ),

    // Suoraan oikealle ulos.
    Arrow(
      row: 1,
      column: 2,
      direction: ArrowDirection.right,
    ),

    // Suoraan alas ulos.
    Arrow(
      row: 2,
      column: 5,
      direction: ArrowDirection.down,
    ),

    // Suoraan vasemmalle ulos.
    Arrow(
      row: 5,
      column: 4,
      direction: ArrowDirection.left,
    ),

    // Pitkä vaakasuora nuoli.
    Arrow(
      row: 4,
      column: 1,
      direction: ArrowDirection.right,
      length: 2,
    ),

    // Pitkä pystysuora nuoli.
    Arrow(
      row: 5,
      column: 6,
      direction: ArrowDirection.up,
      length: 2,
    ),

    // Bentti nuoli:
    // oikealle -> alas -> oikealle.
    Arrow.bent(
      row: 0,
      column: 3,
      direction: ArrowDirection.right,
      path: [
        ArrowDirection.right,
        ArrowDirection.down,
        ArrowDirection.right,
      ],
    ),
  ],
);