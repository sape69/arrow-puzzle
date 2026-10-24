import '../../arrow.dart';

class PlacementCandidate {
  const PlacementCandidate({
    required this.arrow,
    required this.priority,
  });

  final Arrow arrow;

  /// Higher priority means that this candidate
  /// should be considered earlier by the generator.
  final int priority;
}