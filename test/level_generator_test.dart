import 'package:flutter_test/flutter_test.dart';

import 'package:arrow_puzzle/game/game_board.dart';
import 'package:arrow_puzzle/game/level_generator.dart';
import 'package:arrow_puzzle/game/level_solver.dart';

void main() {
  test(
    'Level 8 generator creates a solvable 10x10 level',
    () {
      const generator = LevelGenerator();
      const solver = LevelSolver();

      final level = generator.generate(
        size: 10,
        arrowCount: 24,
        seed: 8,
        maxAttempts: 1000,
      );

      final board = GameBoard(
        level: level,
      );

      final solution = solver.findSolution(board);

      expect(
        level.size,
        10,
      );

      expect(
        level.arrows.length,
        24,
      );

      expect(
        solution,
        isNotNull,
      );

      expect(
        solution!.length,
        24,
      );
    },
  );
}