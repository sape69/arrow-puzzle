import 'dart:math';

import '../../arrow.dart';
import '../../level_data.dart';
import '../geometry/arrow_geometry.dart';
import '../rules/placement_rules.dart';
import 'placement_candidate.dart';
import 'reverse_arrow_factory.dart';
import 'reverse_placement_strategy.dart';

class ReverseGenerator {
  const ReverseGenerator({
    ArrowGeometry geometry = const ArrowGeometry(),
    PlacementRules rules = const PlacementRules(),
    ReverseArrowFactory arrowFactory =
        const ReverseArrowFactory(),
    ReversePlacementStrategy placementStrategy =
        const ReversePlacementStrategy(),
  })  : _geometry = geometry,
        _rules = rules,
        _arrowFactory = arrowFactory,
        _placementStrategy = placementStrategy;

  final ArrowGeometry _geometry;
  final PlacementRules _rules;
  final ReverseArrowFactory _arrowFactory;
  final ReversePlacementStrategy _placementStrategy;

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
      final arrows = _buildLevel(
        size: size,
        arrowCount: arrowCount,
        random: random,
        maxAttemptsPerArrow: maxAttemptsPerArrow,
        maxLength: maxLength,
      );

      if (arrows != null) {
        return LevelData(
          size: size,
          arrows: arrows,
        );
      }
    }

    throw StateError(
      'Could not generate a reverse level with '
      '$arrowCount arrows on a ${size}x$size board.',
    );
  }

  List<Arrow>? _buildLevel({
    required int size,
    required int arrowCount,
    required Random random,
    required int maxAttemptsPerArrow,
    required int maxLength,
  }) {
    final arrows = <Arrow>[];

    for (var index = 0;
        index < arrowCount;
        index++) {
      final candidate =
          _findCandidate(
        size: size,
        existing: arrows,
        random: random,
        maxAttempts: maxAttemptsPerArrow,
        maxLength: maxLength,
      );

      if (candidate == null) {
        return null;
      }

      arrows.add(candidate.arrow);
    }

    if (!_rules.canPlaceAll(
      arrows,
    )) {
      return null;
    }

    return arrows;
  }

  PlacementCandidate? _findCandidate({
    required int size,
    required List<Arrow> existing,
    required Random random,
    required int maxAttempts,
    required int maxLength,
  }) {
    return _placementStrategy.findCandidate(
      boardSize: size,
      existing: existing,
      random: random,
      maxAttempts: maxAttempts,
      maxLength: maxLength,
    );
  }

  Arrow _createFallbackCandidate({
    required int size,
    required Random random,
    required ArrowDirection direction,
    required int maxLength,
  }) {
    return _arrowFactory.create(
      boardSize: size,
      random: random,
      exitDirection: direction,
      maxLength: maxLength,
    );
  }

  bool _isValidCandidate(
    Arrow candidate,
    List<Arrow> existing,
    int size,
  ) {
    if (!_geometry.isValidPath(
      candidate,
      size,
    )) {
      return false;
    }

    return _rules.canPlace(
      candidate,
      existing,
    );
  }

  int _distanceToEdge(
    Arrow arrow,
    int size,
  ) {
    final tip = _geometry.tip(
      arrow,
    );

    switch (_geometry.exitDirection(
      arrow,
    )) {
      case ArrowDirection.up:
        return tip.row;

      case ArrowDirection.right:
        return size - 1 - tip.column;

      case ArrowDirection.down:
        return size - 1 - tip.row;

      case ArrowDirection.left:
        return tip.column;
    }
  }
}