import 'dart:math';

import '../../arrow.dart';
import '../../level_data.dart';
import 'reverse_solution_direction_builder.dart';
import 'reverse_solution_direction_plan.dart';
import 'reverse_solution_placement_validator.dart';
import 'reverse_solution_arrow_placer.dart';
import 'reverse_solution_order.dart';
import 'reverse_solution_order_validator.dart';

class ReverseSolutionGenerator {
const ReverseSolutionGenerator({
ReverseSolutionDirectionBuilder directionBuilder =
const ReverseSolutionDirectionBuilder(),
ReverseSolutionArrowPlacer arrowPlacer =
const ReverseSolutionArrowPlacer(),
ReverseSolutionPlacementValidator placementValidator =
const ReverseSolutionPlacementValidator(),
ReverseSolutionOrderValidator orderValidator =
const ReverseSolutionOrderValidator(),
})  : _directionBuilder = directionBuilder,
_arrowPlacer = arrowPlacer,
_placementValidator = placementValidator,
_orderValidator = orderValidator;

final ReverseSolutionDirectionBuilder _directionBuilder;
final ReverseSolutionArrowPlacer _arrowPlacer;
final ReverseSolutionPlacementValidator _placementValidator;
final ReverseSolutionOrderValidator _orderValidator;

LevelData generate({
required int size,
required int arrowCount,
required Random random,
int maxAttemptsPerArrow = 100,
int maxLength = 3,
}) {
if (size < 1) {
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

for (var restart = 0; restart < 20; restart++) {
  final directionPlan =
      _directionBuilder.build(
    arrowCount: arrowCount,
    random: random,
  );

  final arrows = _buildArrows(
    size: size,
    directionPlan: directionPlan,
    random: random,
    maxAttemptsPerArrow:
        maxAttemptsPerArrow,
    maxLength: maxLength,
  );

  if (arrows == null) {
    continue;
  }

  final order = ReverseSolutionOrder(
    arrows: arrows,
  );

  if (!_orderValidator.isValid(
    arrows: arrows,
    order: order,
    boardSize: size,
  )) {
    continue;
  }

  return LevelData(
    size: size,
    arrows: arrows,
  );
}

throw StateError(
  'Could not generate a solution-first level '
  'with $arrowCount arrows on a '
  '${size}x$size board.',
);

}

List<Arrow>? _buildArrows({
required int size,
required ReverseSolutionDirectionPlan
directionPlan,
required Random random,
required int maxAttemptsPerArrow,
required int maxLength,
}) {
final arrows = <Arrow>[];

for (final direction
    in directionPlan.orderedDirections) {
  Arrow? placed;

  for (var attempt = 0;
      attempt < maxAttemptsPerArrow;
      attempt++) {
    final candidate = _arrowPlacer.place(
      boardSize: size,
      existing: arrows,
      exitDirection: direction,
      random: random,
      maxAttempts: 1,
      maxLength: maxLength,
    );

    if (candidate == null) {
      continue;
    }

    if (!_placementValidator.canPlace(
      candidate: candidate,
      existing: arrows,
      boardSize: size,
    )) {
      continue;
    }

    placed = candidate;
    break;
  }

  if (placed == null) {
    return null;
  }

  arrows.add(placed);
}

return arrows;

}
}