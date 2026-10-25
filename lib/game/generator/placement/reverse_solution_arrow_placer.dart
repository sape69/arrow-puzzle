import 'dart:math';

import '../../arrow.dart';
import '../geometry/arrow_geometry.dart';
import '../rules/placement_rules.dart';
import 'reverse_arrow_factory.dart';

class ReverseSolutionArrowPlacer {
const ReverseSolutionArrowPlacer({
ArrowGeometry geometry = const ArrowGeometry(),
PlacementRules rules = const PlacementRules(),
ReverseArrowFactory arrowFactory =
const ReverseArrowFactory(),
})  : _geometry = geometry,
_rules = rules,
_arrowFactory = arrowFactory;

final ArrowGeometry _geometry;
final PlacementRules _rules;
final ReverseArrowFactory _arrowFactory;

Arrow? place({
required int boardSize,
required List<Arrow> existing,
required ArrowDirection exitDirection,
required Random random,
int maxAttempts = 100,
int maxLength = 3,
}) {
if (boardSize < 1) {
throw ArgumentError(
'Board size must be positive.',
);
}

if (maxAttempts < 1) {
  throw ArgumentError(
    'Maximum attempts must be positive.',
  );
}

if (maxLength < 1) {
  throw ArgumentError(
    'Maximum arrow length must be positive.',
  );
}

for (var attempt = 0;
    attempt < maxAttempts;
    attempt++) {
  final candidate = _arrowFactory.create(
    boardSize: boardSize,
    random: random,
    exitDirection: exitDirection,
    maxLength: maxLength,
  );

  if (!_geometry.isValidPath(
    candidate,
    boardSize,
  )) {
    continue;
  }

  if (!_rules.canPlace(
    candidate,
    existing,
  )) {
    continue;
  }

  if (!_preservesExistingExits(
    candidate,
    existing,
    boardSize,
  )) {
    continue;
  }

  return candidate;
}

return null;

}

bool _preservesExistingExits(
Arrow candidate,
List<Arrow> existing,
int boardSize,
) {
final simulated = <Arrow>[
...existing,
candidate,
];

for (final arrow in existing) {
  if (!_canLeave(
    arrow,
    simulated,
    boardSize,
  )) {
    return false;
  }
}

return true;

}

bool _canLeave(
Arrow arrow,
List<Arrow> arrows,
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
}