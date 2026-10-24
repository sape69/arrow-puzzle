import '../../arrow.dart';

import 'arrow_direction_rule.dart';
import 'arrow_overlap_rule.dart';
import 'arrow_spacing_rule.dart';

class PlacementRules {
  const PlacementRules({
    ArrowOverlapRule overlapRule = const ArrowOverlapRule(),
    ArrowDirectionRule directionRule = const ArrowDirectionRule(),
    ArrowSpacingRule spacingRule = const ArrowSpacingRule(),
  })  : _overlapRule = overlapRule,
        _directionRule = directionRule,
        _spacingRule = spacingRule;

  final ArrowOverlapRule _overlapRule;
  final ArrowDirectionRule _directionRule;
  final ArrowSpacingRule _spacingRule;

  bool canPlace(
    Arrow candidate,
    List<Arrow> existing, {
    int minimumDistance = 1,
  }) {
    if (!_overlapRule.canPlace(
      candidate,
      existing,
    )) {
      return false;
    }

    if (!_directionRule.canPlace(
      candidate,
      existing,
    )) {
      return false;
    }

    if (!_spacingRule.canPlace(
      candidate,
      existing,
      minimumDistance: minimumDistance,
    )) {
      return false;
    }

    return true;
  }

  bool hasOverlap(
    Arrow candidate,
    List<Arrow> existing,
  ) {
    return !_overlapRule.canPlace(
      candidate,
      existing,
    );
  }

  bool hasBadDirection(
    Arrow candidate,
    List<Arrow> existing,
  ) {
    return !_directionRule.canPlace(
      candidate,
      existing,
    );
  }

  bool hasInsufficientSpacing(
    Arrow candidate,
    List<Arrow> existing, {
    int minimumDistance = 1,
  }) {
    return !_spacingRule.canPlace(
      candidate,
      existing,
      minimumDistance: minimumDistance,
    );
  }
}