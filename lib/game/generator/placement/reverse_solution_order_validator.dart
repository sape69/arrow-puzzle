import '../../arrow.dart';
import '../geometry/arrow_geometry.dart';
import 'reverse_solution_order.dart';

class ReverseSolutionOrderValidator {
const ReverseSolutionOrderValidator({
ArrowGeometry geometry = const ArrowGeometry(),
}) : _geometry = geometry;

final ArrowGeometry _geometry;

bool isValid({
required List<Arrow> arrows,
required ReverseSolutionOrder order,
required int boardSize,
}) {
if (boardSize < 1) {
return false;
}

if (order.length != arrows.length) {
  return false;
}

final remaining = List<Arrow>.from(
  arrows,
);

for (final arrow in order.orderedArrows) {
  if (!remaining.contains(arrow)) {
    return false;
  }

  if (!_canLeave(
    arrow,
    remaining,
    boardSize,
  )) {
    return false;
  }

  remaining.remove(arrow);
}

return remaining.isEmpty;

}

bool _canLeave(
Arrow arrow,
List<Arrow> remaining,
int boardSize,
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

  if (!_geometry.isInside(
    current,
    boardSize,
  )) {
    return true;
  }

  for (final other in remaining) {
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
}