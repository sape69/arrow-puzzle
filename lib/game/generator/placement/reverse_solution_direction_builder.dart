import 'dart:math';

import '../../arrow.dart';
import 'reverse_solution_direction_plan.dart';

class ReverseSolutionDirectionBuilder {
const ReverseSolutionDirectionBuilder();

ReverseSolutionDirectionPlan build({
required int arrowCount,
required Random random,
}) {
if (arrowCount < 1) {
throw ArgumentError(
'Arrow count must be positive.',
);
}

final directions = <ArrowDirection>[];

for (var index = 0;
    index < arrowCount;
    index++) {
  directions.add(
    ArrowDirection.values[
      random.nextInt(
        ArrowDirection.values.length,
      )
    ],
  );
}

return ReverseSolutionDirectionPlan(
  directions: directions,
);

}
}