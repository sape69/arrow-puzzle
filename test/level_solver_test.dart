import 'package:flutter_test/flutter_test.dart';

import 'package:arrow_puzzle/game/arrow.dart';
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

      const expectedArrowCount = 20;

      const solver = LevelSolver();

      final solution = solver.findSolution(board);

      expect(
        board.size,
        9,
      );

      expect(
        solution,
        isNotNull,
        reason:
            'The generated Level 7 data is not solvable.',
      );

      expect(
        solution!.length,
        expectedArrowCount,
      );
    },
  );

  test(
    'Level 7 long right arrow should have a clear exit',
    () {
      final board = GameBoard(
        level: level7,
      );

      final arrow = board.arrows.firstWhere(
        (arrow) =>
            arrow.row == 4 &&
            arrow.column == 3 &&
            arrow.direction ==
                ArrowDirection.right &&
            arrow.length == 3,
      );

      expect(
        board.canExit(arrow),
        isTrue,
        reason:
            'The long right arrow at row 4, column 3 '
            'should have a clear path to the right edge.',
      );
    },
  );
}