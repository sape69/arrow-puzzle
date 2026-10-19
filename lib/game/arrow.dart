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
  });

  final int row;
  final int column;
  final ArrowDirection direction;
}