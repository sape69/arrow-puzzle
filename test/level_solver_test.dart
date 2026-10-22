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

      final movable = board.arrows
          .where(board.canExit)
          .toList();

      expect(
        board.size,
        9,
      );

      expect(
        board.arrows.length,
        20,
      );

      expect(
        movable,
        isNotEmpty,
        reason:
            'Level 7 has no arrow that can exit at the start.',
      );

      final solution = solver.findSolution(board);

      expect(
        solution,
        isNotNull,
        reason:
            'Level 7 has ${movable.length} initially movable arrows, '
            'but the solver could not find a complete solution.',
      );

      expect(
        solution!.length,
        board.arrows.length,
      );
    },
  );
}