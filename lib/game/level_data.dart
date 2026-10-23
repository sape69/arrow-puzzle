import 'arrow.dart';
import 'levels/level_2.dart';
import 'levels/level_3.dart';
import 'levels/level_4.dart';
import 'levels/level_5.dart';
import 'levels/level_6.dart';
import 'levels/level_7.dart';
import 'levels/level_8.dart';

class LevelData {
  const LevelData({
    required this.arrows,
    this.size = 7,
  });

  final List<Arrow> arrows;
  final int size;
}

const List<LevelData> levels = [
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
  level2,
  level3,
  level4,
  level5,
  level6,
  level7,
  level8,
];