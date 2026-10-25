import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:arrow_puzzle/game/game_board.dart';
import 'package:arrow_puzzle/game/generator/placement/reverse_solution_generator.dart';
import 'package:arrow_puzzle/game/generator/rules/placement_rules.dart';
import 'package:arrow_puzzle/game/level_solver.dart';

void main() {
const generator = ReverseSolutionGenerator();
const rules = PlacementRules();
const solver = LevelSolver();

test(
'solution generator should survive many random seeds',
() {
for (var seed = 0; seed < 25; seed++) {
final level = generator.generate(
size: 10,
arrowCount: 20,
random: Random(seed),
);

    expect(
      level.arrows.length,
      20,
      reason: 'Failed with seed $seed.',
    );

    expect(
      rules.canPlaceAll(
        level.arrows,
      ),
      isTrue,
      reason:
          'Overlapping arrows with seed $seed.',
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
          'Generated level was not solvable '
          'with seed $seed.',
    );
  }
},

);

test(
'solution generator should survive many small-board seeds',
() {
for (var seed = 25; seed < 50; seed++) {
final level = generator.generate(
size: 6,
arrowCount: 10,
random: Random(seed),
);

    expect(
      level.arrows.length,
      10,
      reason: 'Failed with seed $seed.',
    );

    expect(
      rules.canPlaceAll(
        level.arrows,
      ),
      isTrue,
      reason:
          'Overlapping arrows with seed $seed.',
    );
  }
},

);

test(
'solution generator should produce the same level for the same seed',
() {
final first = generator.generate(
size: 10,
arrowCount: 20,
random: Random(12345),
);

  final second = generator.generate(
    size: 10,
    arrowCount: 20,
    random: Random(12345),
  );

  expect(
    first.size,
    second.size,
  );

  expect(
    first.arrows,
    equals(second.arrows),
  );
},

);
}