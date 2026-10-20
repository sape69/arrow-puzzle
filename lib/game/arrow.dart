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
  });

  final int row;
  final int column;
  final ArrowDirection direction;

  /// Kuinka monta ruutua pitkä nuoli on.
  final int length;
}