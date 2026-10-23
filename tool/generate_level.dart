import 'dart:io';

import 'package:arrow_puzzle/game/level_generator.dart';

void main(List<String> arguments) {
  final level = _argument(
    arguments,
    '--level',
  );

  final size = _argument(
    arguments,
    '--size',
  );

  final arrows = _argument(
    arguments,
    '--arrows',
  );

  final seed = _argument(
    arguments,
    '--seed',
  );

  if (level == null ||
      size == null ||
      arrows == null ||
      seed == null) {
    stderr.writeln(
      'Missing generator arguments.',
    );
    exitCode = 1;
    return;
  }

  final levelNumber = int.tryParse(level);
  final boardSize = int.tryParse(size);
  final arrowCount = int.tryParse(arrows);
  final randomSeed = int.tryParse(seed);

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

  final level = generator.generate(
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