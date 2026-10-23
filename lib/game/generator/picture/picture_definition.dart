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
    if (row < 0 ||
        row >= height ||
        column < 0 ||
        column >= width) {
      return false;
    }

    return pattern[row][column] == '#';
  }
}

const stellaCatPicture = PictureDefinition(
  name: 'Stella',
  pattern: [
    '...#####...',
    '..#######..',
    '.#########.',
    '.##..#..##.',
    '###.....###',
    '###########',
    '###########',
    '.#########.',
    '..#######..',
    '...#####...',
    '...........',
  ],
);