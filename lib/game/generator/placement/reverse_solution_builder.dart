import '../../arrow.dart';
import '../geometry/arrow_geometry.dart';

class ReverseSolutionBuilder {
  const ReverseSolutionBuilder({
    ArrowGeometry geometry = const ArrowGeometry(),
  }) : _geometry = geometry;

  final ArrowGeometry _geometry;

  List<Arrow> build(
    List<Arrow> arrows,
  ) {
    if (arrows.isEmpty) {
      return const [];
    }

    final remaining = List<Arrow>.from(
      arrows,
    );

    final solution = <Arrow>[];

    while (remaining.isNotEmpty) {
      final removable = _findRemovableArrow(
        remaining,
      );

      if (removable == null) {
        throw StateError(
          'Could not build a reverse solution. '
          'No arrow can currently leave the board.',
        );
      }

      solution.add(removable);
      remaining.remove(removable);
    }

    return solution;
  }

  Arrow? _findRemovableArrow(
    List<Arrow> remaining,
  ) {
    for (final arrow in remaining) {
      if (_canLeave(
        arrow,
        remaining,
      )) {
        return arrow;
      }
    }

    return null;
  }

  bool _canLeave(
    Arrow arrow,
    List<Arrow> remaining,
  ) {
    final tip = _geometry.tip(
      arrow,
    );

    final direction = _geometry.exitDirection(
      arrow,
    );

    var current = tip;

    while (true) {
      current = current.move(
        direction,
      );

      if (!_isInside(
        current,
        remaining,
      )) {
        return true;
      }
    }
  }

  bool _isInside(
    GridCell cell,
    List<Arrow> arrows,
  ) {
    for (final arrow in arrows) {
      final cells = _geometry.cells(
        arrow,
      );

      if (cells.contains(cell)) {
        return true;
      }
    }

    return false;
  }
}