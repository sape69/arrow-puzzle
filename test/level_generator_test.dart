import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:arrow_puzzle/game/game_board.dart';
import 'package:arrow_puzzle/game/level_generator.dart';
import 'package:arrow_puzzle/game/level_solver.dart';

void main() {
  test(
    'Level 8 generator creates a solvable 10x10 level',
    () {
      const generator = LevelGenerator();
      const solver = LevelSolver();

      final level = generator.generate(
        size: 10,
        arrowCount: 24,
        seed: 8,
        maxAttempts: 1000,
      );

      final board = GameBoard(
        level: level,
      );

      final solution = solver.findSolution(board);

      expect(
        level.size,
        10,
      );

      expect(
        level.arrows.length,
        24,
      );

      expect(
        solution,
        isNotNull,
      );

      expect(
        solution!.length,
        24,
      );

      final outputDirectory = Directory(
        'build/generated',
      );

      outputDirectory.createSync(
        recursive: true,
      );

      final outputFile = File(
        'build/generated/level_8.dart',
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
        'const level8 = LevelData(',
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