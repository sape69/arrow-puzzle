import 'dart:math';

import '../../arrow.dart';
import '../geometry/arrow_geometry.dart';
import '../rules/placement_rules.dart';
import 'placement_candidate.dart';
import 'reverse_arrow_factory.dart';

class ReversePlacementStrategy {
  const ReversePlacementStrategy({
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

  PlacementCandidate? findCandidate({
    required int boardSize,
    required List<Arrow> existing,
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

    final candidates = <PlacementCandidate>[];

    for (var attempt = 0;
        attempt < maxAttempts;
        attempt++) {
      final direction = _randomDirection(
        random,
      );

      final candidate = _arrowFactory.create(
        boardSize: boardSize,
        random: random,
        exitDirection: direction,
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

      candidates.add(
        PlacementCandidate(
          arrow: candidate,
          priority: _priority(
            candidate,
            boardSize,
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
      random.nextInt(
        best.length,
      )
    ];
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

  int _priority(
    Arrow arrow,
    int boardSize,
  ) {
    final tip = _geometry.tip(
      arrow,
    );

    final distanceToEdge =
        _distanceToEdge(
      tip.row,
      tip.column,
      boardSize,
      _geometry.exitDirection(
        arrow,
      ),
    );

    return 100 - distanceToEdge;
  }

  int _distanceToEdge(
    int row,
    int column,
    int boardSize,
    ArrowDirection direction,
  ) {
    switch (direction) {
      case ArrowDirection.up:
        return row;

      case ArrowDirection.right:
        return boardSize - 1 - column;

      case ArrowDirection.down:
        return boardSize - 1 - row;

      case ArrowDirection.left:
        return column;
    }
  }
}