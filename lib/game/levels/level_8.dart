import '../arrow.dart';
import '../level_data.dart';

const level8 = LevelData(
  size: 7,
  arrows: [
    // Testinuoli:
    // Tämä on aluksi toisen nuolen estämä.
    Arrow(
      row: 1,
      column: 0,
      direction: ArrowDirection.right,
    ),

    // Estää ensimmäisen nuolen.
    Arrow(
      row: 1,
      column: 4,
      direction: ArrowDirection.down,
    ),

    // Bentti nuoli omalla, täysin erillisellä reitillään.
    Arrow.bent(
      row: 0,
      column: 6,
      direction: ArrowDirection.down,
      path: [
        ArrowDirection.down,
        ArrowDirection.down,
        ArrowDirection.left,
      ],
    ),

    // Suoraan ylös ulos.
    Arrow(
      row: 5,
      column: 1,
      direction: ArrowDirection.up,
    ),

    // Vasemmalle ulos.
    Arrow(
      row: 3,
      column: 5,
      direction: ArrowDirection.left,
    ),

    // Pitkä vapaa nuoli.
    Arrow(
      row: 6,
      column: 2,
      direction: ArrowDirection.right,
      length: 2,
    ),
  ],
);