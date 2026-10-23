import '../../arrow.dart';

import 'arrow_geometry.dart';

class ArrowCollision {
  const ArrowCollision({
    ArrowGeometry geometry = const ArrowGeometry(),
  }) : _geometry = geometry;

  final ArrowGeometry _geometry;

  bool overlaps(
    Arrow first,
    Arrow second,
  ) {
    final firstCells = _geometry.cells(first);
    final secondCells = _geometry.cells(second);

    final occupied = firstCells.toSet();

    for (final cell in secondCells) {
      if (occupied.contains(cell)) {
        return true;
      }
    }

    return false;
  }

  bool canPlace(
    Arrow candidate,
    List<Arrow> existing,
  ) {
    for (final arrow in existing) {
      if (overlaps(
        candidate,
        arrow,
      )) {
        return false;
      }
    }

    return true;
  }

  bool hasCollision(
    Arrow candidate,
    List<Arrow> existing,
  ) {
    return !canPlace(
      candidate,
      existing,
    );
  }

  List<Arrow> findCollisions(
    Arrow candidate,
    List<Arrow> existing,
  ) {
    final collisions = <Arrow>[];

    for (final arrow in existing) {
      if (overlaps(
        candidate,
        arrow,
      )) {
        collisions.add(arrow);
      }
    }

    return collisions;
  }

  bool allNonOverlapping(
    List<Arrow> arrows,
  ) {
    for (var i = 0; i < arrows.length; i++) {
      for (var j = i + 1; j < arrows.length; j++) {
        if (overlaps(
          arrows[i],
          arrows[j],
        )) {
          return false;
        }
      }
    }

    return true;
  }
}