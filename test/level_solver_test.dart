import 'package:flutter_test/flutter_test.dart';

import 'package:arrow_puzzle/game/game_board.dart';
import 'package:arrow_puzzle/game/level_solver.dart';
import 'package:arrow_puzzle/game/levels/level_9.dart';

void main() {
  test(
    'Level 9 should be solvable',
    () {
      final board = GameBoard(
        level: level9,
      );

      const expectedArrowCount = 26;

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
            'The generated Level 9 data is not solvable.',
      );

      expect(
        solution!.length,
        expectedArrowCount,
      );
    },
  );
}