import '../../arrow.dart';

class PictureArrowDefinition {
  const PictureArrowDefinition({
    required this.row,
    required this.column,
    required this.path,
  });

  final int row;
  final int column;
  final List<ArrowDirection> path;
}

const stellaPictureArrows = <PictureArrowDefinition>[
  // ============================================================
  // 🐱 STELLA — KORVAT
  // ============================================================

  PictureArrowDefinition(
    row: 1,
    column: 2,
    path: [
      ArrowDirection.up,
      ArrowDirection.right,
      ArrowDirection.right,
      ArrowDirection.down,
    ],
  ),

  PictureArrowDefinition(
    row: 1,
    column: 8,
    path: [
      ArrowDirection.up,
      ArrowDirection.left,
      ArrowDirection.left,
      ArrowDirection.down,
    ],
  ),

  // ============================================================
  // 🐱 STELLA — PÄÄN YLÄOSA
  // ============================================================

  PictureArrowDefinition(
    row: 3,
    column: 2,
    path: [
      ArrowDirection.right,
      ArrowDirection.right,
      ArrowDirection.right,
    ],
  ),

  PictureArrowDefinition(
    row: 3,
    column: 8,
    path: [
      ArrowDirection.left,
      ArrowDirection.left,
      ArrowDirection.left,
    ],
  ),

  // ============================================================
  // 🐱 STELLA — KASVOT
  // ============================================================

  PictureArrowDefinition(
    row: 4,
    column: 3,
    path: [
      ArrowDirection.down,
      ArrowDirection.right,
      ArrowDirection.right,
      ArrowDirection.down,
    ],
  ),

  PictureArrowDefinition(
    row: 4,
    column: 7,
    path: [
      ArrowDirection.down,
      ArrowDirection.left,
      ArrowDirection.left,
      ArrowDirection.down,
    ],
  ),

  // ============================================================
  // 👀 SILMÄT
  // ============================================================

  PictureArrowDefinition(
    row: 5,
    column: 4,
    path: [
      ArrowDirection.right,
    ],
  ),

  PictureArrowDefinition(
    row: 5,
    column: 6,
    path: [
      ArrowDirection.left,
    ],
  ),

  // ============================================================
  // 😺 KUONO
  // ============================================================

  PictureArrowDefinition(
    row: 6,
    column: 5,
    path: [
      ArrowDirection.down,
      ArrowDirection.left,
      ArrowDirection.right,
    ],
  ),

  // ============================================================
  // 🐱 VARTALO
  // ============================================================

  PictureArrowDefinition(
    row: 7,
    column: 3,
    path: [
      ArrowDirection.down,
      ArrowDirection.right,
      ArrowDirection.right,
      ArrowDirection.right,
      ArrowDirection.down,
    ],
  ),

  PictureArrowDefinition(
    row: 7,
    column: 7,
    path: [
      ArrowDirection.down,
      ArrowDirection.left,
      ArrowDirection.left,
      ArrowDirection.left,
      ArrowDirection.down,
    ],
  ),

  PictureArrowDefinition(
    row: 9,
    column: 3,
    path: [
      ArrowDirection.right,
      ArrowDirection.right,
      ArrowDirection.right,
      ArrowDirection.right,
    ],
  ),

  // ============================================================
  // 🐈 HÄNTÄ
  // ============================================================

  PictureArrowDefinition(
    row: 8,
    column: 8,
    path: [
      ArrowDirection.right,
      ArrowDirection.down,
      ArrowDirection.down,
      ArrowDirection.left,
      ArrowDirection.left,
    ],
  ),
];