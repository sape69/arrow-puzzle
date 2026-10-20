import '../arrow.dart';
import '../level_data.dart';

const level5 = LevelData(
  size: 8,
  arrows: [
    // Yläreuna
    Arrow(
      row: 0,
      column: 0,
      direction: ArrowDirection.right,
      length: 3,
    ),
    Arrow(
      row: 0,
      column: 5,
      direction: ArrowDirection.down,
      length: 2,
    ),

    // Vasen reuna
    Arrow(
      row: 2,
      column: 0,
      direction: ArrowDirection.down,
      length: 3,
    ),
    Arrow(
      row: 6,
      column: 0,
      direction: ArrowDirection.right,
      length: 2,
    ),

    // Pitkä keskialueen nuoli
    Arrow(
      row: 3,
      column: 2,
      direction: ArrowDirection.right,
      length: 3,
    ),

    // Mutkitteleva nuoli
    Arrow.bent(
      row: 1,
      column: 3,
      path: [
        ArrowDirection.down,
        ArrowDirection.down,
        ArrowDirection.right,
        ArrowDirection.right,
      ],
    ),

    // Toinen mutkitteleva nuoli
    Arrow.bent(
      row: 2,
      column: 6,
      path: [
        ArrowDirection.left,
        ArrowDirection.left,
        ArrowDirection.down,
        ArrowDirection.down,
      ],
    ),

    // Keskellä oleva mutkitteleva nuoli
    Arrow.bent(
      row: 5,
      column: 4,
      path: [
        ArrowDirection.up,
        ArrowDirection.left,
        ArrowDirection.left,
        ArrowDirection.down,
      ],
    ),

    // Alareunan pitkä nuoli
    Arrow(
      row: 7,
      column: 2,
      direction: ArrowDirection.right,
      length: 3,
    ),

    // Oikea reuna
    Arrow(
      row: 4,
      column: 7,
      direction: ArrowDirection.up,
      length: 3,
    ),
    Arrow(
      row: 7,
      column: 7,
      direction: ArrowDirection.up,
      length: 2,
    ),

    // Viimeinen pitkä nuoli
    Arrow(
      row: 5,
      column: 1,
      direction: ArrowDirection.right,
      length: 2,
    ),
  ],
);