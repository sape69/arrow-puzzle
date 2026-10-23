import 'dart:io';

import 'package:arrow_puzzle/game/level_generator.dart';

void main(List<String> arguments) {
  final levelArgument = _argument(
    arguments,
    '--level',
  );

  final sizeArgument = _argument(
    arguments,
    '--size',
  );

  final arrowsArgument = _argument(
    arguments,
    '--arrows',
  );

  final seedArgument = _argument(
    arguments,
    '--seed',
  );

  if (levelArgument == null ||
      sizeArgument == null ||
      arrowsArgument == null ||
      seedArgument == null) {
    stderr.writeln(
      'Missing generator arguments.',
    );
    exitCode = 1;
    return;
  }

  final levelNumber = int.tryParse(
    levelArgument,
  );

  final boardSize = int.tryParse(
    sizeArgument,
  );

  final arrowCount = int.tryParse(
    arrowsArgument,
  );

  final randomSeed = int.tryParse(
    seedArgument,
  );

  if (levelNumber == null ||
      boardSize == null ||
      arrowCount == null ||
      randomSeed == null) {
    stderr.writeln(
      'All arguments must be integers.',
    );
    exitCode = 1;
    return;
  }

  if (levelNumber < 1 ||
      boardSize < 1 ||
      arrowCount < 1) {
    stderr.writeln(
      'Level, size and arrow count must be positive.',
    );
    exitCode = 1;
    return;
  }

  const generator = LevelGenerator();

  stdout.writeln(
    'Generating Level $levelNumber...',
  );
  stdout.writeln(
    'Board: ${boardSize}x$boardSize',
  );
  stdout.writeln(
    'Arrows: $arrowCount',
  );
  stdout.writeln(
    'Seed: $randomSeed',
  );

  final generatedLevel = generator.generate(
    size: boardSize,
    arrowCount: arrowCount,
    seed: randomSeed,
    maxAttempts: 1000,
  );

  final outputDirectory = Directory(
    'build/generated',
  );

  outputDirectory.createSync(
    recursive: true,
  );

  final outputFile = File(
    'build/generated/level_$levelNumber.dart',
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
    'const level$levelNumber = LevelData(',
  );
  buffer.writeln(
    '  size: ${generatedLevel.size},',
  );
  buffer.writeln(
    '  arrows: [',
  );

  for (final arrow in generatedLevel.arrows) {
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

  stdout.writeln();
  stdout.writeln(
    'Level generated successfully.',
  );
  stdout.writeln(
    'Output: ${outputFile.path}',
  );
}

String? _argument(
  List<String> arguments,
  String name,
) {
  final index = arguments.indexOf(name);

  if (index == -1 ||
      index + 1 >= arguments.length) {
    return null;
  }

  return arguments[index + 1];
}