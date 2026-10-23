import '../../arrow.dart';

class PictureDefinition {
  const PictureDefinition({
    required this.name,
    required this.pattern,
  });

  final String name;
  final List<String> pattern;

  int get height => pattern.length;

  int get width {
    if (pattern.isEmpty) {
      return 0;
    }

    return pattern.first.length;
  }

  bool isFilled(
    int row,
    int column,
  ) {
    return directionAt(
          row,
          column,
        ) !=
        null;
  }

  ArrowDirection? directionAt(
    int row,
    int column,
  ) {
    if (row < 0 ||
        row >= height ||
        column < 0 ||
        column >= width) {
      return null;
    }

    final character = pattern[row][column];

    switch (character) {
      case '^':
        return ArrowDirection.up;

      case '>':
        return ArrowDirection.right;

      case 'v':
        return ArrowDirection.down;

      case '<':
        return ArrowDirection.left;

      default:
        return null;
    }
  }
}

const stellaCatPicture = PictureDefinition(
  name: 'Stella',
  pattern: [
    '..^^...^^..',
    '.^^^^.^^^^.',
    '^^^^^^^^^^^',
    '^^>^^^^^<^^',
    '^^^.....^^^',
    '^^.......^^',
    '^^.>...<.^^',
    '.^^.....^^.',
    '.^^^^^^^^^.',
    '..^^^^^^^..',
    '...^^^^^...',
  ],
);