import 'dart:math';

import '../../arrow.dart';
import '../../level_data.dart';
import '../geometry/arrow_geometry.dart';
import '../rules/placement_rules.dart';
import 'placement_candidate.dart';
import 'reverse_arrow_factory.dart';

class ReverseGenerator {
  const ReverseGenerator({
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

  LevelData generate({
    required int size,
    required int arrowCount,
    required Random random,
    int maxAttemptsPerArrow = 100,
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
        'Maximum attempts must be positive.',
      );
    }

    final arrows = <Arrow>[];

    for (var index = 0; index < arrowCount; index++) {
      final candidate = _findCandidate(
        size: size,
        existing: arrows,
        random: random,
        maxAttempts: maxAttemptsPerArrow,
      );

      if (candidate == null) {
        throw StateError(
          'Could not place arrow ${index + 1} '
          'of $arrowCount.',
        );
      }

      arrows.add(
        candidate.arrow,
      );
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
    required int maxAttempts,
  }) {
    final candidates = <PlacementCandidate>[];

    for (var attempt = 0;
        attempt < maxAttempts;
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