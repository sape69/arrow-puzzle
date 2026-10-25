import 'dart:math';

import '../arrow.dart';
import '../level_data.dart';
import 'geometry/arrow_geometry.dart';
import 'placement/placement_candidate.dart';
import 'placement/reverse_arrow_factory.dart';
import 'placement/reverse_solution_validator.dart';
import 'rules/placement_rules.dart';

class ReverseLevelGenerator {
  const ReverseLevelGenerator({
    ArrowGeometry geometry = const ArrowGeometry(),
    PlacementRules rules = const PlacementRules(),
    ReverseArrowFactory arrowFactory =
        const ReverseArrowFactory(),
    ReverseSolutionValidator solutionValidator =
        const ReverseSolutionValidator(),
  })  : _geometry = geometry,
        _rules = rules,
        _arrowFactory = arrowFactory,
        _solutionValidator = solutionValidator;

  final ArrowGeometry _geometry;
  final PlacementRules _rules;
  final ReverseArrowFactory _arrowFactory;
  final ReverseSolutionValidator _solutionValidator;

  LevelData generate({
    required int size,
    required int arrowCount,
    required Random random,
    int maxAttempts = 1000,
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

    if (maxAttempts < 1) {
      throw ArgumentError(
        'Maximum attempts must be positive.',
      );
    }

    for (var attempt = 0;
        attempt < maxAttempts;
        attempt++) {
      final level = _tryGenerate(
        size: size,
        arrowCount: arrowCount,
        random: random,
      );

      if (level != null) {
        return level;
      }
    }

    throw StateError(
      'Could not generate a valid reverse level '
      'after $maxAttempts attempts.',
    );
  }

  LevelData? _tryGenerate({
    required int size,
    required int arrowCount,
    required Random random,
  }) {
    final arrows = <Arrow>[];

    for (var index = 0;
        index < arrowCount;
        index++) {
      final candidate = _findCandidate(
        size: size,
        existing: arrows,
        random: random,
      );

      if (candidate == null) {
        return null;
      }

      arrows.add(
        candidate.arrow,
      );
    }

    final solutionOrder = _buildSolutionOrder(
      arrows,
      random,
    );

    if (solutionOrder == null) {
      return null;
    }

    final valid = _solutionValidator.isValid(
      arrows: arrows,
      solutionOrder: solutionOrder,
      boardSize: size,
    );

    if (!valid) {
      return null;
    }

    return LevelData(
      size: size,
      arrows: arrows,
    );
  }

  PlacementCandidate? _findCandidate({
    required int size,
    required List<Arrow> existing,
    required Random random,
  }) {
    final candidates = <PlacementCandidate>[];

    for (var attempt = 0;
        attempt < 100;
        attempt++) {
      final arrow = _arrowFactory.create(
        boardSize: size,
        random: random,
      );

      if (!_geometry.isValidPath(
        arrow,
        size,
      )) {
        continue;
      }

      if (!_rules.canPlace(
        arrow,
        existing,
      )) {
        continue;
      }

      candidates.add(
        PlacementCandidate(
          arrow: arrow,
          priority: _priority(
            arrow,
            size,
          ),
        ),
      );
    }

    if (candidates.isEmpty) {
      return null;
    }

    candidates.sort(
      (first, second) =>
          second.priority.compareTo(
        first.priority,
      ),
    );

    final bestPriority =
        candidates.first.priority;

    final best = candidates
        .where(
          (candidate) =>
              candidate.priority == bestPriority,
        )
        .toList();

    return best[
      random.nextInt(best.length)
    ];
  }

  List<Arrow>? _buildSolutionOrder(
    List<Arrow> arrows,
    Random random,
  ) {
    final remaining = List<Arrow>.from(
      arrows,
    );

    final solution = <Arrow>[];

    while (remaining.isNotEmpty) {
      final removable = <Arrow>[];

      for (final arrow in remaining) {
        if (_canLeave(
          arrow,
          remaining,
        )) {
          removable.add(arrow);
        }
      }

      if (removable.isEmpty) {
        return null;
      }

      final selected = removable[
        random.nextInt(
          removable.length,
        )
      ];

      solution.add(selected);
      remaining.remove(selected);
    }

    return solution;
  }

  bool _canLeave(
    Arrow arrow,
    List<Arrow> remaining,
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
        _currentBoardSize(
          current,
          remaining,
        ),
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

  int _currentBoardSize(
    GridCell current,
    List<Arrow> arrows,
  ) {
    var maximum = 0;

    for (final arrow in arrows) {
      for (final cell in _geometry.cells(
        arrow,
      )) {
        if (cell.row > maximum) {
          maximum = cell.row;
        }

        if (cell.column > maximum) {
          maximum = cell.column;
        }
      }
    }

    if (current.row > maximum) {
      maximum = current.row;
    }

    if (current.column > maximum) {
      maximum = current.column;
    }

    return maximum + 1;
  }

  int _priority(
    Arrow arrow,
    int size,
  ) {
    final tip = _geometry.tip(
      arrow,
    );

    final distanceToEdge =
        _distanceToEdge(
      tip.row,
      tip.column,
      size,
      _geometry.exitDirection(
        arrow,
      ),
    );

    return 100 - distanceToEdge;
  }

  int _distanceToEdge(
    int row,
    int column,
    int size,
    ArrowDirection direction,
  ) {
    switch (direction) {
      case ArrowDirection.up:
        return row;

      case ArrowDirection.right:
        return size - 1 - column;

      case ArrowDirection.down:
        return size - 1 - row;

      case ArrowDirection.left:
        return column;
    }
  }
}