import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:arrow_puzzle/game/game_board.dart';
import 'package:arrow_puzzle/game/level_generator.dart';
import 'package:arrow_puzzle/game/level_solver.dart';

void main() {
  test(
    'Level 7 generator creates a solvable 9x9 level',
    () {
      const generator = LevelGenerator();
      const solver = LevelSolver();

      final level = generator.generate(
        size: 9,
        arrowCount: 20,
        seed: 7,
        maxAttempts: 1000,
      );

      final board = GameBoard(
        level: level,
      );

      final solution = solver.findSolution(board);

      expect(
        level.size,
        9,
      );

      expect(
        level.arrows.length,
        20,
      );

      expect(
        solution,
        isNotNull,
      );

      expect(
        solution!.length,
        level.arrows.length,
      );

      final outputDirectory = Directory(
        'build/generated',
      );

      outputDirectory.createSync(
        recursive: true,
      );

      final outputFile = File(
        'build/generated/level_7.dart',
      );

      final buffer = StringBuffer();

      buffer.writeln(
        "import '../lib/game/arrow.dart';",
      );
      buffer.writeln(
        "import '../lib/game/level_data.dart';",
      );
      buffer.writeln();
      buffer.writeln(
        'const level7 = LevelData(',
      );
      buffer.writeln(
        '  size: ${level.size},',
      );
      buffer.writeln(
        '  arrows: [',
      );

      for (final arrow in level.arrows) {
        buffer.writeln(
          '    Arrow(',
        );
        buffer.writeln(
          '      row: ${arrow.row},',
        );
        buffer.writeln(
          '      column: ${arrow.column},',
        );
        buffer.writeln(
          '      direction: '
          'ArrowDirection.${arrow.direction.name},',
        );
        buffer.writeln(
          '      length: ${arrow.length},',
        );
        buffer.writeln(
          '    ),',
        );
      }

      buffer.writeln(
        '  ],',
      );
      buffer.writeln(
        ');',
      );

      outputFile.writeAsStringSync(
        buffer.toString(),
      );

      expect(
        outputFile.existsSync(),
        isTrue,
      );
    },
  );
}