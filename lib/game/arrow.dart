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
        length = path.length;

  final int row;
  final int column;
  final ArrowDirection direction;
  final int length;
  final List<ArrowDirection>? path;

  bool get isBent => path != null;

  int get segmentCount {
    return isBent ? path!.length : length;
  }
}