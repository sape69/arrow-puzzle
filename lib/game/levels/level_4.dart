import '../arrow.dart';
import '../level_data.dart';

final level4 = LevelData(
  size: 8,
  arrows: [
    // Yläreuna
    const Arrow(
      row: 0,
      column: 1,
      direction: ArrowDirection.down,
      length: 2,
    ),
    const Arrow(
      row: 0,
      column: 4,
      direction: ArrowDirection.right,
      length: 3,
    ),

    // Vasemman reunan nuolet
    const Arrow(
      row: 2,
      column: 0,
      direction: ArrowDirection.right,
      length: 2,
    ),
    const Arrow(
      row: 5,
      column: 0,
      direction: ArrowDirection.up,
      length: 3,
    ),

    // Keskialue
    const Arrow(
      row: 2,
      column: 3,
      direction: ArrowDirection.down,
      length: 2,
    ),
    const Arrow(
      row: 3,
      column: 5,
      direction: ArrowDirection.left,
      length: 2,
    ),

    // Mutkitteleva nuoli
    Arrow.bent(
      row: 4,
      column: 2,
      path: [
        ArrowDirection.right,
        ArrowDirection.right,
        ArrowDirection.down,
      ],
    ),

    // Toinen mutkitteleva nuoli
    Arrow.bent(
      row: 6,
      column: 5,
      path: [
        ArrowDirection.up,
        ArrowDirection.up,
        ArrowDirection.left,
      ],
    ),

    // Alareuna
    const Arrow(
      row: 7,
      column: 1,
      direction: ArrowDirection.right,
      length: 3,
    ),
    const Arrow(
      row: 7,
      column: 6,
      direction: ArrowDirection.up,
      length: 2,
    ),

    // Oikea reuna
    const Arrow(
      row: 2,
      column: 7,
      direction: ArrowDirection.down,
      length: 2,
    ),
    const Arrow(
      row: 5,
      column: 7,
      direction: ArrowDirection.left,
      length: 2,
    ),
  ],
);