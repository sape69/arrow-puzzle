import 'package:flutter_test/flutter_test.dart';

import 'package:arrow_puzzle/game/arrow.dart';
import 'package:arrow_puzzle/game/game_board.dart';
import 'package:arrow_puzzle/game/level_data.dart';
import 'package:arrow_puzzle/game/level_generator.dart';
import 'package:arrow_puzzle/game/level_solver.dart';
import 'package:arrow_puzzle/game/generator/difficulty_analyzer.dart';
import 'package:arrow_puzzle/game/generator/level_difficulty.dart';

void main() {
  test(
    'Level generator should create a solvable normal level',
    () {
      const generator = LevelGenerator();

      final level = generator.generate(
        size: 7,
        arrowCount: 12,
        seed: 1,
        maxAttempts: 1000,
        difficulty: LevelDifficulty.normal,
      );

      expect(
        level.size,
        7,
      );

      expect(
        level.arrows.length,
        12,
      );

      final board = GameBoard(
        level: level,
      );

      const solver = LevelSolver();

      final solution = solver.findSolution(board);

      expect(
        solution,
        isNotNull,
        reason:
            'The generated level should be solvable.',
      );

      expect(
        solution!.length,
        12,
      );
    },
  );

  test(
    'Difficulty analyzer should classify an easy level',
    () {
      const level = LevelData(
        size: 4,
        arrows: [
          Arrow(
            row: 0,
            column: 0,
            direction: ArrowDirection.up,
          ),
          Arrow(
            row: 0,
            column: 1,
            direction: ArrowDirection.up,
          ),
          Arrow(
            row: 0,
            column: 2,
            direction: ArrowDirection.up,
          ),
          Arrow(
            row: 0,
            column: 3,
            direction: ArrowDirection.up,
          ),
        ],
      );

      final board = GameBoard(
        level: level,
      );

      const solver = LevelSolver();
      const analyzer = DifficultyAnalyzer();

      final solution = solver.findSolution(board);

      expect(
        solution,
        isNotNull,
      );

      expect(
        analyzer.analyze(
          level,
          solution!,
        ),
        LevelDifficulty.easy,
      );
    },
  );
}