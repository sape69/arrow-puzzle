import '../../arrow.dart';
import '../geometry/arrow_geometry.dart';

class ArrowSpacingRule {
  const ArrowSpacingRule({
    ArrowGeometry geometry = const ArrowGeometry(),
  }) : _geometry = geometry;

  final ArrowGeometry _geometry;

  bool canPlace(
    Arrow candidate,
    List<Arrow> existing, {
    int minimumDistance = 1,
  }) {
    for (final arrow in existing) {
      if (!hasEnoughDistance(
        candidate,
        arrow,
        minimumDistance: minimumDistance,
      )) {
        return false;
      }
    }

    return true;
  }

  bool hasEnoughDistance(
    Arrow first,
    Arrow second, {
    int minimumDistance = 1,
  }) {
    final firstCells = _geometry.cells(first);
    final secondCells = _geometry.cells(second);

    for (final firstCell in firstCells) {
      for (final secondCell in secondCells) {
        final distance = _manhattanDistance(
          firstCell,
          secondCell,
        );

        if (distance < minimumDistance) {
          return false;
        }
      }
    }

    return true;
  }

  int minimumDistanceBetween(
    Arrow first,
    Arrow second,
  ) {
    final firstCells = _geometry.cells(first);
    final secondCells = _geometry.cells(second);

    var minimumDistance = 1 << 30;

    for (final firstCell in firstCells) {
      for (final secondCell in secondCells) {
        final distance = _manhattanDistance(
          firstCell,
          secondCell,
        );

        if (distance < minimumDistance) {
          minimumDistance = distance;
        }
      }
    }

    return minimumDistance;
  }

  int _manhattanDistance(
    GridCell first,
    GridCell second,
  ) {
    return (first.row - second.row).abs() +
        (first.column - second.column).abs();
  }
}