import 'package:flutter_test/flutter_test.dart';

import 'package:arrow_puzzle/game/game_board.dart';
import 'package:arrow_puzzle/game/level_solver.dart';
import 'package:arrow_puzzle/game/levels/level_8.dart';

void main() {
  test(
    'Level 8 should be solvable',
    () {
      final board = GameBoard(
        level: level8,
      );

      const expectedArrowCount = 24;

      const solver = LevelSolver();

      final solution = solver.findSolution(board);

      expect(
        board.size,
        10,
      );

      expect(
        solution,
        isNotNull,
        reason:
            'The generated Level 8 data is not solvable.',
      );

      expect(
        solution!.length,
        expectedArrowCount,
      );
    },
  );
}