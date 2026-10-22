import 'package:flutter_test/flutter_test.dart';

import 'package:arrow_puzzle/game/game_board.dart';
import 'package:arrow_puzzle/game/level_data.dart';
import 'package:arrow_puzzle/game/level_solver.dart';

void main() {
  test(
    'Level 7 should be solvable',
    () {
      final board = GameBoard(
        level: levels[6],
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
      );

      expect(
        solution!.length,
        board.arrows.length,
      );
    },
  );
}