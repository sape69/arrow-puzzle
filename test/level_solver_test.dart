import 'package:flutter_test/flutter_test.dart';

import 'package:arrow_puzzle/game/game_board.dart';
import 'package:arrow_puzzle/game/level_data.dart';
import 'package:arrow_puzzle/game/level_solver.dart';

void main() {
  test(
    'Level 7 diagnostic',
    () {
      final board = GameBoard(
        level: levels[6],
      );

      const solver = LevelSolver();

      final movable = board.arrows
          .where(board.canExit)
          .toList();

      print('');
      print('=== LEVEL 7 DIAGNOSTIC ===');
      print('Board size: ${board.size}');
      print('Arrow count: ${board.arrows.length}');
      print('Movable arrows: ${movable.length}');

      for (var i = 0; i < movable.length; i++) {
        final arrow = movable[i];

        print(
          'Movable ${i + 1}: '
          'row=${arrow.row}, '
          'column=${arrow.column}, '
          'direction=${arrow.direction}, '
          'length=${arrow.length}',
        );
      }

      final solution = solver.findSolution(board);

      print(
        'Solver solution: '
        '${solution == null ? 'NONE' : 'FOUND'}',
      );

      if (solution != null) {
        print(
          'Solution length: ${solution.length}',
        );
      }

      print('==========================');
      print('');

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
      );

      expect(
        solution,
        isNotNull,
      );
    },
  );
}