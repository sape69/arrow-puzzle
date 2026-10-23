import 'dart:math';

import 'generator/candidate_generator.dart';
import 'generator/difficulty_analyzer.dart';
import 'generator/level_difficulty.dart';
import 'generator/level_validator.dart';
import 'level_data.dart';

class LevelGenerator {
  const LevelGenerator();

  LevelData generate({
    required int size,
    required int arrowCount,
    int seed = 1,
    int maxAttempts = 1000,
    LevelDifficulty difficulty = LevelDifficulty.normal,
  }) {
    final random = Random(seed);

    const candidateGenerator = CandidateGenerator();
    const validator = LevelValidator();
    const analyzer = DifficultyAnalyzer();

    for (var attempt = 0;
        attempt < maxAttempts;
        attempt++) {
      final level = candidateGenerator.generate(
        size: size,
        arrowCount: arrowCount,
        random: random,
      );

      if (level.arrows.length != arrowCount) {
        continue;
      }

      final solution = validator.findSolution(level);

      if (solution == null) {
        continue;
      }

      final actualDifficulty = analyzer.analyze(
        level,
        solution,
      );

      if (actualDifficulty != difficulty) {
        continue;
      }

      return level;
    }

    throw StateError(
      'Could not generate a $difficulty level '
      'after $maxAttempts attempts.',
    );
  }
}