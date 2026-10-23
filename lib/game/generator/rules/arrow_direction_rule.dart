import '../../arrow.dart';
import '../geometry/arrow_geometry.dart';

class ArrowDirectionRule {
  const ArrowDirectionRule({
    ArrowGeometry geometry = const ArrowGeometry(),
  }) : _geometry = geometry;

  final ArrowGeometry _geometry;

  bool canPlace(
    Arrow candidate,
    List<Arrow> existing,
  ) {
    for (final arrow in existing) {
      if (_pointsDirectlyAtEachOther(
        candidate,
        arrow,
      )) {
        return false;
      }
    }

    return true;
  }

  bool pointsAtEachOther(
    Arrow first,
    Arrow second,
  ) {
    return _pointsDirectlyAtEachOther(
      first,
      second,
    );
  }

  bool _pointsDirectlyAtEachOther(
    Arrow first,
    Arrow second,
  ) {
    final firstTip = _geometry.tip(first);
    final secondTip = _geometry.tip(second);

    final firstDirection = _geometry.exitDirection(first);
    final secondDirection = _geometry.exitDirection(second);

    final firstNext = firstTip.move(firstDirection);
    final secondNext = secondTip.move(secondDirection);

    final firstPointsToSecond =
        _sameCell(
          firstNext,
          secondTip,
        );

    final secondPointsToFirst =
        _sameCell(
          secondNext,
          firstTip,
        );

    return firstPointsToSecond &&
        secondPointsToFirst;
  }

  bool _sameCell(
    GridCell first,
    GridCell second,
  ) {
    return first.row == second.row &&
        first.column == second.column;
  }
}