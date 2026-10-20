import '../arrow.dart';
import '../level_data.dart';

final level4 = LevelData(
  size: 8,
  arrows: [
    // Yksittäinen nuoli
    const Arrow(
      row: 6,
      column: 2,
      direction: ArrowDirection.down,
    ),

    // Mutkitteleva nuoli
    Arrow.bent(
      row: 0,
      column: 7,
      path: [
        ArrowDirection.down,
        ArrowDirection.left,
        ArrowDirection.down,
        ArrowDirection.right,
      ],
    ),

    // Pitkä suora nuoli
    const Arrow(
      row: 5,
      column: 4,
      direction: ArrowDirection.down,
      length: 2,
    ),

    // Mutkitteleva nuoli
    Arrow.bent(
      row: 7,
      column: 6,
      path: [
        ArrowDirection.right,
        ArrowDirection.up,
        ArrowDirection.left,
      ],
    ),

    // Yksittäinen nuoli
    const Arrow(
      row: 3,
      column: 2,
      direction: ArrowDirection.up,
    ),

    // Mutkitteleva nuoli
    Arrow.bent(
      row: 1,
      column: 2,
      path: [
        ArrowDirection.right,
        ArrowDirection.up,
        ArrowDirection.right,
        ArrowDirection.down,
      ],
    ),

    // Mutkitteleva nuoli
    Arrow.bent(
      row: 3,
      column: 6,
      path: [
        ArrowDirection.right,
        ArrowDirection.down,
        ArrowDirection.down,
      ],
    ),

    // Yksittäinen nuoli
    const Arrow(
      row: 5,
      column: 5,
      direction: ArrowDirection.right,
    ),

    // Pitkä vaakasuora nuoli
    const Arrow(
      row: 4,
      column: 4,
      direction: ArrowDirection.left,
      length: 2,
    ),

    // Mutkitteleva nuoli
    Arrow.bent(
      row: 2,
      column: 1,
      path: [
        ArrowDirection.left,
        ArrowDirection.up,
        ArrowDirection.right,
      ],
    ),

    // Reunanuoli
    const Arrow(
      row: 0,
      column: 0,
      direction: ArrowDirection.left,
    ),

    // Reunanuoli
    const Arrow(
      row: 7,
      column: 0,
      direction: ArrowDirection.left,
    ),
  ],
);