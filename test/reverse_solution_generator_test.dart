import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:arrow_puzzle/game/game_board.dart';
import 'package:arrow_puzzle/game/generator/geometry/arrow_geometry.dart';
import 'package:arrow_puzzle/game/generator/placement/reverse_solution_generator.dart';
import 'package:arrow_puzzle/game/generator/placement/reverse_solution_order.dart';
import 'package:arrow_puzzle/game/generator/placement/reverse_solution_order_validator.dart';
import 'package:arrow_puzzle/game/generator/rules/placement_rules.dart';
import 'package:arrow_puzzle/game/level_solver.dart';

void main() {
const generator = ReverseSolutionGenerator();
const geometry = ArrowGeometry();
const rules = PlacementRules();
const orderValidator =
ReverseSolutionOrderValidator();
const solver = LevelSolver();

test(
'solution generator should create the requested number of arrows',
() {
final level = generator.generate(
size: 10,
arrowCount: 20,
random: Random(1),
);

  expect(
    level.size,
    10,
  );

  expect(
    level.arrows.length,
    20,
  );
},

);

test(
'solution generator should not create overlapping arrows',
() {
final level = generator.generate(
size: 10,
arrowCount: 20,
random: Random(2),
);

  expect(
    rules.canPlaceAll(
      level.arrows,
    ),
    isTrue,
  );
},

);

test(
'solution generator should keep every arrow inside the board',
() {
final level = generator.generate(
size: 10,
arrowCount: 20,
random: Random(3),
);

  for (final arrow in level.arrows) {
    expect(
      geometry.isValidPath(
        arrow,
        level.size,
      ),
      isTrue,
    );
  }
},

);

test(
'solution generator should produce a valid solution order',
() {
final level = generator.generate(
size: 10,
arrowCount: 20,
random: Random(4),
);

  final order = ReverseSolutionOrder(
    arrows: level.arrows,
  );

  expect(
    orderValidator.isValid(
      arrows: level.arrows,
      order: order,
      boardSize: level.size,
    ),
    isTrue,
  );
},

);

test(
'solution generated level should be solvable',
() {
final level = generator.generate(
size: 10,
arrowCount: 20,
random: Random(5),
);

  final board = GameBoard(
    level: level,
  );

  final solution =
      solver.findSolution(board);

  expect(
    solution,
    isNotNull,
    reason:
        'A solution-generated level should be solvable.',
  );

  expect(
    solution!.length,
    20,
  );
},

);

test(
'solution generator should work with a smaller board',
() {
final level = generator.generate(
size: 6,
arrowCount: 10,
random: Random(6),
);

  expect(
    level.arrows.length,
    10,
  );

  expect(
    rules.canPlaceAll(
      level.arrows,
    ),
    isTrue,
  );
},

);

test(
'solution generator should work with a larger board',
() {
final level = generator.generate(
size: 15,
arrowCount: 40,
random: Random(7),
);

  expect(
    level.arrows.length,
    40,
  );

  expect(
    rules.canPlaceAll(
      level.arrows,
    ),
    isTrue,
  );

  for (final arrow in level.arrows) {
    expect(
      geometry.isValidPath(
        arrow,
        level.size,
      ),
      isTrue,
    );
  }
},

);

test(
'solution generator should reject an invalid board size',
() {
expect(
() => generator.generate(
size: 0,
arrowCount: 5,
random: Random(8),
),
throwsArgumentError,
);
},
);

test(
'solution generator should reject an invalid arrow count',
() {
expect(
() => generator.generate(
size: 5,
arrowCount: 0,
random: Random(9),
),
throwsArgumentError,
);
},
);
}