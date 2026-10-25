import 'dart:math';

import '../../arrow.dart';
import 'reverse_solution_arrow_placer.dart';
import 'reverse_solution_direction_plan.dart';
import 'reverse_solution_order.dart';
import 'reverse_solution_order_validator.dart';

class ReverseSolutionPlacementBuilder {
const ReverseSolutionPlacementBuilder({
ReverseSolutionArrowPlacer arrowPlacer =
const ReverseSolutionArrowPlacer(),
ReverseSolutionOrderValidator orderValidator =
const ReverseSolutionOrderValidator(),
})  : _arrowPlacer = arrowPlacer,
_orderValidator = orderValidator;

final ReverseSolutionArrowPlacer _arrowPlacer;
final ReverseSolutionOrderValidator _orderValidator;

ReverseSolutionOrder build({
required int boardSize,
required ReverseSolutionDirectionPlan directionPlan,
required Random random,
int maxAttemptsPerArrow = 100,
int maxLength = 3,
}) {
if (boardSize < 1) {
throw ArgumentError(
'Board size must be positive.',
);
}

if (directionPlan.isEmpty) {
  return const ReverseSolutionOrder(
    arrows: [],
  );
}

if (maxAttemptsPerArrow < 1) {
  throw ArgumentError(
    'Maximum attempts per arrow must be positive.',
  );
}

if (maxLength < 1) {
  throw ArgumentError(
    'Maximum arrow length must be positive.',
  );
}

final arrows = <Arrow>[];

for (final direction
    in directionPlan.orderedDirections) {
  final arrow = _arrowPlacer.place(
    boardSize: boardSize,
    existing: arrows,
    exitDirection: direction,
    random: random,
    maxAttempts: maxAttemptsPerArrow,
    maxLength: maxLength,
  );

  if (arrow == null) {
    throw StateError(
      'Could not place an arrow for '
      'exit direction $direction.',
    );
  }

  arrows.add(arrow);
}

final order = ReverseSolutionOrder(
  arrows: arrows,
);

if (!_orderValidator.isValid(
  arrows: arrows,
  order: order,
  boardSize: boardSize,
)) {
  throw StateError(
    'Generated solution order is invalid.',
  );
}

return order;

}
}