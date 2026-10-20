enum ArrowDirection {
  up,
  right,
  down,
  left,
}

class Arrow {
  const Arrow({
    required this.row,
    required this.column,
    required this.direction,
    this.length = 1,
  }) : path = const [];

  const Arrow.bent({
    required this.row,
    required this.column,
    required this.direction,
    required this.path,
  }) : length = 1;

  final int row;
  final int column;

  /// Nuolen ensimmäinen/suuntaava suunta.
  final ArrowDirection direction;

  /// Suoran nuolen pituus.
  final int length;

  /// Mutkittelevan nuolen koko reitti.
  ///
  /// Jokainen alkio kertoo yhden ruudun liikkeen.
  final List<ArrowDirection> path;

  bool get isBent => path.isNotEmpty;

  int get segmentCount {
    if (isBent) {
      return path.length;
    }

    return length;
  }

  /// Mutkittelevan nuolen viimeinen suunta.
  ArrowDirection get exitDirection {
    if (path.isEmpty) {
      return direction;
    }

    return path.last;
  }
}