import '../../arrow.dart';
import '../geometry/arrow_geometry.dart';

class ReverseSolutionPath {
const ReverseSolutionPath({
ArrowGeometry geometry = const ArrowGeometry(),
}) : _geometry = geometry;

final ArrowGeometry _geometry;

List<GridCell> cellsToExit({
required Arrow arrow,
required int boardSize,
}) {
if (boardSize < 1) {
throw ArgumentError(
'Board size must be positive.',
);
}

final path = <GridCell>[];
var current = _geometry.tip(arrow);

final direction =
    _geometry.exitDirection(arrow);

while (true) {
  current = current.move(direction);

  if (!_geometry.isInside(
    current,
    boardSize,
  )) {
    break;
  }

  path.add(current);
}

return List<GridCell>.unmodifiable(
  path,
);

}

bool canExit({
required Arrow arrow,
required List<Arrow> arrows,
required int boardSize,
}) {
final exitPath = cellsToExit(
arrow: arrow,
boardSize: boardSize,
);

for (final cell in exitPath) {
  for (final other in arrows) {
    if (other == arrow) {
      continue;
    }

    if (_geometry.cells(other).contains(
          cell,
        )) {
      return false;
    }
  }
}

return true;

}
}