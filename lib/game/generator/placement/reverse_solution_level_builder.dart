import 'dart:math';

import '../../arrow.dart';
import 'reverse_solution_arrow_placer.dart';
import 'reverse_solution_order.dart';
import 'reverse_solution_order_validator.dart';
import 'reverse_solution_plan.dart';

class ReverseSolutionLevelBuilder {
const ReverseSolutionLevelBuilder({
ReverseSolutionArrowPlacer arrowPlacer =
const ReverseSolutionArrowPlacer(),
ReverseSolutionOrderValidator orderValidator =
const ReverseSolutionOrderValidator(),
})  : _arrowPlacer = arrowPlacer,
_orderValidator = orderValidator;

final ReverseSolutionArrowPlacer _arrowPlacer;
final ReverseSolutionOrderValidator _orderValidator;

ReverseSolutionPlan build({
required int boardSize,
required int arrowCount,
required Random random,
int maxAttemptsPerArrow = 100,
int maxLength = 3,
}) {
if (boardSize < 1) {
throw ArgumentError(
'Board size must be positive.',
);
}

if (arrowCount < 1) {
  throw ArgumentError(
    'Arrow count must be positive.',
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

for (var index = 0;
    index < arrowCount;
    index++) {
  final direction = _randomDirection(
    random,
  );

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
      'Could not place arrow ${index + 1} '
      'of $arrowCount.',
    );
  }

  arrows.add(arrow);
}

final order = ReverseSolutionOrder(
  arrows: List<Arrow>.from(arrows),
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

return ReverseSolutionPlan(
  arrows: order.orderedArrows,
);

}

ArrowDirection _randomDirection(
Random random,
) {
return ArrowDirection.values[
random.nextInt(
ArrowDirection.values.length,
)
];
}
}