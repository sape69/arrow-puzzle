import 'package:flutter_test/flutter_test.dart';

import 'package:arrow_puzzle/game/game_board.dart';
import 'package:arrow_puzzle/game/level_solver.dart';
import 'package:arrow_puzzle/game/levels/level_7.dart';

void main() {
  test(
    'Level 7 should be solvable',
    () {
      final board = GameBoard(
        level: level7,
      );

      const solver = LevelSolver();

      final solution = solver.findSolution(board);

      expect(
        board.size,
        9,
      );

      expect(
        board.arrows.length,
        20,
      );

      expect(
        solution,
        isNotNull,
        reason:
            'The generated Level 7 data is not solvable.',
      );

      expect(
        solution!.length,
        board.arrows.length,
      );
    },
  );
}