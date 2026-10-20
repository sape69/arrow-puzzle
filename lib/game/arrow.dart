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
  }) : path = null;

  const Arrow.bent({
    required this.row,
    required this.column,
    required this.path,
  })  : direction = path.last,
        length = path.length,
        assert(path.isNotEmpty);

  final int row;
  final int column;

  /// Suoran nuolen suunta.
  ///
  /// Mutkittelevalla nuolella tämä on viimeisen
  /// osuuden suunta eli nuolen kärjen suunta.
  final ArrowDirection direction;

  /// Suoran nuolen pituus.
  final int length;

  /// Mutkittelevan nuolen liikesuunta ruutu kerrallaan.
  ///
  /// Esimerkiksi:
  /// [right, right, down, down]
  ///
  /// tekee tällaisen reitin:
  ///
  /// → → ↓
  ///     ↓
  final List<ArrowDirection>? path;

  bool get isBent => path != null;

  int get segmentCount {
    return isBent ? path!.length : length;
  }
}