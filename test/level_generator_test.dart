import 'package:flutter_test/flutter_test.dart';

import 'package:arrow_puzzle/game/game_board.dart';
import 'package:arrow_puzzle/game/level_generator.dart';
import 'package:arrow_puzzle/game/level_solver.dart';

void main() {
  test(
    'Generated level should be solvable',
    () {
      const generator = LevelGenerator();
      const solver = LevelSolver();

      final level = generator.generate(
        size: 9,
        arrowCount: 20,
        seed: 7,
      );

      final board = GameBoard(
        level: level,
      );

      final solution = solver.findSolution(board);

      expect(
        level.arrows.length,
        greaterThan(0),
      );

      expect(
        board.size,
        9,
      );

      expect(
        solution,
        isNotNull,
      );

      expect(
        solution!.length,
        level.arrows.length,
      );
    },
  );
}