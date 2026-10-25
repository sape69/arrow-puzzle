import '../../arrow.dart';
import '../geometry/arrow_geometry.dart';
import 'reverse_solution_order.dart';

class ReverseSolutionOrderBuilder {
const ReverseSolutionOrderBuilder({
ArrowGeometry geometry = const ArrowGeometry(),
}) : _geometry = geometry;

final ArrowGeometry _geometry;

ReverseSolutionOrder build(
List<Arrow> arrows, {
required int boardSize,
}) {
if (boardSize < 1) {
throw ArgumentError(
'Board size must be positive.',
);
}

if (arrows.isEmpty) {
  return const ReverseSolutionOrder(
    arrows: [],
  );
}

final remaining = List<Arrow>.from(
  arrows,
);

final order = <Arrow>[];

while (remaining.isNotEmpty) {
  final removable = _findRemovable(
    remaining,
    boardSize,
  );

  if (removable.isEmpty) {
    throw StateError(
      'Could not build a solution order. '
      'No arrow can currently leave the board.',
    );
  }

  final selected = removable.first;

  order.add(selected);
  remaining.remove(selected);
}

return ReverseSolutionOrder(
  arrows: order,
);

}

List<Arrow> _findRemovable(
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