import '../../arrow.dart';
import '../geometry/arrow_geometry.dart';
import '../rules/placement_rules.dart';

class ReversePlacement {
  const ReversePlacement({
    ArrowGeometry geometry = const ArrowGeometry(),
    PlacementRules rules = const PlacementRules(),
  })  : _geometry = geometry,
        _rules = rules;

  final ArrowGeometry _geometry;
  final PlacementRules _rules;

  bool canPlace(
    Arrow candidate,
    List<Arrow> existing,
    int boardSize,
  ) {
    if (!_geometry.isValidPath(
      candidate,
      boardSize,
    )) {
      return false;
    }

    if (!_rules.canPlace(
      candidate,
      existing,
    )) {
      return false;
    }

    return true;
  }

  bool preservesSolutionOrder(
    Arrow candidate,
    List<Arrow> existing,
    List<Arrow> solutionOrder,
    int boardSize,
  ) {
    if (!canPlace(
      candidate,
      existing,
      boardSize,
    )) {
      return false;
    }

    final simulated = List<Arrow>.from(
      existing,
    );

    simulated.add(candidate);

    for (final arrow in solutionOrder) {
      if (!simulated.contains(arrow)) {
        continue;
      }

      if (!_canLeave(
        arrow,
        simulated,
      )) {
        return false;
      }

      simulated.remove(arrow);
    }

    return true;
  }

  bool _canLeave(
    Arrow arrow,
    List<Arrow> arrows,
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
        _boardSizeFromArrows(
          current,
          arrows,
        ),
      )) {
        return true;
      }

      for (final other in arrows) {
        if (other == arrow) {
          continue;
        }

        if (_geometry.cells(other).contains(
              current,
            )) {
          return false;
        }
      }
    }
  }

  int _boardSizeFromArrows(
    GridCell current,
    List<Arrow> arrows,
  ) {
    var maximum = 0;

    for (final arrow in arrows) {
      for (final cell in _geometry.cells(
        arrow,
      )) {
        maximum = maximum > cell.row
            ? maximum
            : cell.row;

        maximum = maximum > cell.column
            ? maximum
            : cell.column;
      }
    }

    maximum = maximum > current.row
        ? maximum
        : current.row;

    maximum = maximum > current.column
        ? maximum
        : current.column;

    return maximum + 1;
  }
}