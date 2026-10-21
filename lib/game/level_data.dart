import 'arrow.dart';
import 'levels/level_2.dart';
import 'levels/level_3.dart';
import 'levels/level_4.dart';
import 'levels/level_5.dart';
import 'levels/level_6.dart';

class LevelData {
  const LevelData({
    required this.arrows,
    this.size = 7,
  });

  final List<Arrow> arrows;
  final int size;
}

const List<LevelData> levels = [
  // ============================================================
  // LEVEL 1
  // ============================================================

  LevelData(
    size: 7,
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

  level2,

  // ============================================================
  // LEVEL 3
  // ============================================================

  level3,

  // ============================================================
  // LEVEL 4
  // ============================================================

  level4,

  // ============================================================
  // LEVEL 5
  // ============================================================

  level5,

  // ============================================================
  // LEVEL 6
  // ============================================================

  level6,
];