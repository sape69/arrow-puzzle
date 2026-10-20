import 'arrow.dart';

class LevelData {
  const LevelData({
    required this.arrows,
  });

  final List<Arrow> arrows;
}

const List<LevelData> levels = [
  // ============================================================
  // LEVEL 1
  // ============================================================

  LevelData(
    arrows: [
      Arrow(
        row: 1,
        column: 1,
        direction: ArrowDirection.up,
      ),
      Arrow(
        row: 1,
        column: 2,
        direction: ArrowDirection.up,
      ),
      Arrow(
        row: 1,
        column: 3,
        direction: ArrowDirection.up,
      ),
      Arrow(
        row: 1,
        column: 4,
        direction: ArrowDirection.up,
      ),
      Arrow(
        row: 2,
        column: 1,
        direction: ArrowDirection.left,
      ),
      Arrow(
        row: 2,
        column: 3,
        direction: ArrowDirection.up,
      ),
      Arrow(
        row: 2,
        column: 5,
        direction: ArrowDirection.right,
      ),
      Arrow(
        row: 3,
        column: 1,
        direction: ArrowDirection.left,
      ),
      Arrow(
        row: 3,
        column: 2,
        direction: ArrowDirection.down,
      ),
      Arrow(
        row: 3,
        column: 3,
        direction: ArrowDirection.right,
      ),
      Arrow(
        row: 3,
        column: 4,
        direction: ArrowDirection.down,
      ),
      Arrow(
        row: 3,
        column: 5,
        direction: ArrowDirection.right,
      ),
    ],
  ),

  // ============================================================
  // LEVEL 2
  // ============================================================

  LevelData(
    arrows: [
      Arrow(
        row: 0,
        column: 2,
        direction: ArrowDirection.up,
      ),
      Arrow(
        row: 1,
        column: 1,
        direction: ArrowDirection.left,
      ),
      Arrow(
        row: 1,
        column: 3,
        direction: ArrowDirection.down,
      ),
      Arrow(
        row: 1,
        column: 5,
        direction: ArrowDirection.right,
      ),
      Arrow(
        row: 2,
        column: 2,
        direction: ArrowDirection.left,
      ),
      Arrow(
        row: 2,
        column: 3,
        direction: ArrowDirection.right,
      ),
      Arrow(
        row: 2,
        column: 4,
        direction: ArrowDirection.right,
      ),
      Arrow(
        row: 3,
        column: 1,
        direction: ArrowDirection.down,
      ),
      Arrow(
        row: 3,
        column: 2,
        direction: ArrowDirection.right,
      ),
      Arrow(
        row: 3,
        column: 4,
        direction: ArrowDirection.down,
      ),
      Arrow(
        row: 4,
        column: 3,
        direction: ArrowDirection.left,
      ),
      Arrow(
        row: 5,
        column: 3,
        direction: ArrowDirection.down,
      ),
    ],
  ),

  // ============================================================
  // LEVEL 3
  // ============================================================

  LevelData(
    arrows: [
      Arrow(
        row: 0,
        column: 1,
        direction: ArrowDirection.up,
      ),
      Arrow(
        row: 0,
        column: 5,
        direction: ArrowDirection.up,
      ),
      Arrow(
        row: 1,
        column: 2,
        direction: ArrowDirection.left,
      ),
      Arrow(
        row: 1,
        column: 3,
        direction: ArrowDirection.down,
      ),
      Arrow(
        row: 1,
        column: 4,
        direction: ArrowDirection.right,
      ),
      Arrow(
        row: 2,
        column: 1,
        direction: ArrowDirection.down,
      ),
      Arrow(
        row: 2,
        column: 2,
        direction: ArrowDirection.right,
      ),
      Arrow(
        row: 2,
        column: 4,
        direction: ArrowDirection.left,
      ),
      Arrow(
        row: 3,
        column: 2,
        direction: ArrowDirection.up,
      ),
      Arrow(
        row: 3,
        column: 3,
        direction: ArrowDirection.right,
      ),
      Arrow(
        row: 3,
        column: 4,
        direction: ArrowDirection.down,
      ),
      Arrow(
        row: 4,
        column: 1,
        direction: ArrowDirection.left,
      ),
      Arrow(
        row: 4,
        column: 3,
        direction: ArrowDirection.down,
      ),
      Arrow(
        row: 5,
        column: 2,
        direction: ArrowDirection.right,
      ),
    ],
  ),

  // ============================================================
  // LEVEL 4
  // ============================================================

  LevelData(
    arrows: [
      Arrow(
        row: 0,
        column: 1,
        direction: ArrowDirection.right,
      ),
      Arrow(
        row: 0,
        column: 4,
        direction: ArrowDirection.left,
      ),
      Arrow(
        row: 1,
        column: 1,
        direction: ArrowDirection.down,
      ),
      Arrow(
        row: 1,
        column: 2,
        direction: ArrowDirection.right,
      ),
      Arrow(
        row: 1,
        column: 4,
        direction: ArrowDirection.down,
      ),
      Arrow(
        row: 2,
        column: 2,
        direction: ArrowDirection.up,
      ),
      Arrow(
        row: 2,
        column: 3,
        direction: ArrowDirection.left,
      ),
      Arrow(
        row: 2,
        column: 5,
        direction: ArrowDirection.down,
      ),
      Arrow(
        row: 3,
        column: 1,
        direction: ArrowDirection.right,
      ),
      Arrow(
        row: 3,
        column: 2,
        direction: ArrowDirection.down,
      ),
      Arrow(
        row: 3,
        column: 4,
        direction: ArrowDirection.left,
      ),
      Arrow(
        row: 4,
        column: 2,
        direction: ArrowDirection.up,
      ),
      Arrow(
        row: 4,
        column: 3,
        direction: ArrowDirection.right,
      ),
      Arrow(
        row: 5,
        column: 1,
        direction: ArrowDirection.left,
      ),
      Arrow(
        row: 5,
        column: 4,
        direction: ArrowDirection.down,
      ),
    ],
  ),

  // ============================================================
  // LEVEL 5
  // ============================================================

  LevelData(
    arrows: [
      Arrow(
        row: 0,
        column: 2,
        direction: ArrowDirection.down,
      ),
      Arrow(
        row: 0,
        column: 4,
        direction: ArrowDirection.left,
      ),
      Arrow(
        row: 1,
        column: 1,
        direction: ArrowDirection.right,
      ),
      Arrow(
        row: 1,
        column: 2,
        direction: ArrowDirection.left,
      ),
      Arrow(
        row: 1,
        column: 4,
        direction: ArrowDirection.down,
      ),
      Arrow(
        row: 2,
        column: 1,
        direction: ArrowDirection.up,
      ),
      Arrow(
        row: 2,
        column: 3,
        direction: ArrowDirection.right,
      ),
      Arrow(
        row: 2,
        column: 5,
        direction: ArrowDirection.left,
      ),
      Arrow(
        row: 3,
        column: 2,
        direction: ArrowDirection.down,
      ),
      Arrow(
        row: 3,
        column: 3,
        direction: ArrowDirection.up,
      ),
      Arrow(
        row: 3,
        column: 4,
        direction: ArrowDirection.right,
      ),
      Arrow(
        row: 4,
        column: 1,
        direction: ArrowDirection.down,
      ),
      Arrow(
        row: 4,
        column: 3,
        direction: ArrowDirection.left,
      ),
      Arrow(
        row: 4,
        column: 5,
        direction: ArrowDirection.up,
      ),
      Arrow(
        row: 5,
        column: 2,
        direction: ArrowDirection.right,
      ),
      Arrow(
        row: 5,
        column: 4,
        direction: ArrowDirection.down,
      ),
    ],
  ),
];