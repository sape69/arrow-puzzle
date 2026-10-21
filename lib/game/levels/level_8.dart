import '../arrow.dart';
import '../level_data.dart';

const level8 = LevelData(
  size: 7,
  arrows: [
    // Tämä nuoli pääsee oikealle ulos.
    Arrow(
      row: 1,
      column: 0,
      direction: ArrowDirection.right,
    ),

    // Tämä nuoli on ensimmäisen nuolen poistumisreitillä.
    Arrow(
      row: 1,
      column: 4,
      direction: ArrowDirection.down,
    ),

    // Tämä nuoli pääsee suoraan ylös.
    Arrow(
      row: 5,
      column: 1,
      direction: ArrowDirection.up,
    ),

    // Tämä nuoli pääsee vasemmalle.
    Arrow(
      row: 3,
      column: 5,
      direction: ArrowDirection.left,
    ),

    // Pitkä nuoli, jonka reitti on vapaa.
    Arrow(
      row: 6,
      column: 2,
      direction: ArrowDirection.right,
      length: 2,
    ),

    // Bentti nuoli, jonka poistumisreitti on vapaa.
    Arrow.bent(
      row: 0,
      column: 5,
      direction: ArrowDirection.down,
      path: [
        ArrowDirection.down,
        ArrowDirection.left,
      ],
    ),
  ],
);