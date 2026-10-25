import '../../arrow.dart';
import '../geometry/arrow_geometry.dart';

class ReverseSolutionBuilder {
  const ReverseSolutionBuilder({
    ArrowGeometry geometry = const ArrowGeometry(),
  }) : _geometry = geometry;

  final ArrowGeometry _geometry;

  List<Arrow> build(
    List<Arrow> arrows, {
    int? boardSize,
  }) {
    if (arrows.isEmpty) {
      return const [];
    }

    final size = boardSize ?? _inferBoardSize(arrows);

    if (size < 1) {
      throw ArgumentError(
        'Board size must be positive.',
      );
    }

    final remaining = List<Arrow>.from(arrows);
    final solution = <Arrow>[];

    while (remaining.isNotEmpty) {
      final removable = _findRemovableArrows(
        remaining,
        size,
      );

      if (removable.isEmpty) {
        throw StateError(
          'Could not build a reverse solution. '
          'No arrow can currently leave the board.',
        );
      }

      final selected = removable.first;

      solution.add(selected);
      remaining.remove(selected);
    }

    return solution;
  }

  List<Arrow> _findRemovableArrows(
    List<Arrow> remaining,
    int boardSize,
  ) {
    final removable = <Arrow>[];

    for (final arrow in remaining) {
      if (_canLeave(
        arrow,
        remaining,
        boardSize,
      )) {
        removable.add(arrow);
      }
    }

    return removable;
  }

  bool _canLeave(
    Arrow arrow,
    List<Arrow> remaining,
    int boardSize,
  ) {
    final tip = _geometry.tip(
      arrow,
    );

    final direction =
        _geometry.exitDirection(
      arrow,
    );

    var current = tip;

    while (true) {
      current = current.move(
        direction,
      );

      if (!_geometry.isInside(
        current,
        boardSize,
      )) {
        return true;
      }

      if (_isBlocked(
        current,
        arrow,
        remaining,
      )) {
        return false;
      }
    }
  }

  bool _isBlocked(
    GridCell cell,
    Arrow movingArrow,
    List<Arrow> remaining,
  ) {
    for (final other in remaining) {
      if (other == movingArrow) {
        continue;
      }

      if (_geometry.cells(other).contains(
            cell,
          )) {
        return true;
      }
    }

    return false;
  }

  int _inferBoardSize(
    List<Arrow> arrows,
  ) {
    var maximum = 0;

    for (final arrow in arrows) {
      final cells = _geometry.cells(
        arrow,
      );

      for (final cell in cells) {
        if (cell.row > maximum) {
          maximum = cell.row;
        }

        if (cell.column > maximum) {
          maximum = cell.column;
        }
      }
    }

    return maximum + 1;
  }
}