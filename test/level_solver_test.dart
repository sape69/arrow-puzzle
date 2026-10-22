import 'package:flutter_test/flutter_test.dart';

import 'package:arrow_puzzle/game/game_board.dart';
import 'package:arrow_puzzle/game/level_solver.dart';

void main() {
  test(
    'Level 7 should be solvable',
    () {
      final board = GameBoard();

      board.currentLevel = 6;
      board.reset();

      const solver = LevelSolver();

      final solution = solver.findSolution(board);

      expect(solution, isNotNull);

      print(
        'Level 7 solution: '
        '${solution!.length} moves',
      );

      for (var i = 0; i < solution.length; i++) {
        final arrow = solution[i];

        print(
          '${i + 1}. '
          'row=${arrow.row}, '
          'column=${arrow.column}, '
          'direction=${arrow.direction}',
        );
      }
    },
  );
}