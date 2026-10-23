import '../arrow.dart';
import '../game_board.dart';
import '../level_data.dart';

import 'level_difficulty.dart';

class DifficultyAnalyzer {
  const DifficultyAnalyzer();

  LevelDifficulty analyze(
    LevelData level,
    List<Arrow> solution,
  ) {
    final score = calculateScore(
      level,
      solution,
    );

    if (score >= 2.5) {
      return LevelDifficulty.easy;
    }

    if (score >= 1.8) {
      return LevelDifficulty.normal;
    }

    if (score >= 1.3) {
      return LevelDifficulty.hard;
    }

    return LevelDifficulty.expert;
  }

  double calculateScore(
    LevelData level,
    List<Arrow> solution,
  ) {
    if (solution.isEmpty) {
      return double.infinity;
    }

    final board = GameBoard(
      level: level,
    );

    var totalChoices = 0;

    for (final arrow in solution) {
      var movableCount = 0;

      for (final candidate in board.arrows) {
        if (board.canExit(candidate)) {
          movableCount++;
        }
      }

      totalChoices += movableCount;

      if (!board.arrows.contains(arrow)) {
        return double.infinity;
      }

      board.removeArrow(arrow);
    }

    return totalChoices / solution.length;
  }
}