import '../../arrow.dart';

class ReverseSolutionPlan {
  const ReverseSolutionPlan({
    required this.arrows,
  });

  final List<Arrow> arrows;

  int get length => arrows.length;

  bool get isEmpty => arrows.isEmpty;

  bool get isNotEmpty => arrows.isNotEmpty;

  Arrow operator [](int index) {
    return arrows[index];
  }

  List<Arrow> get orderedArrows {
    return List<Arrow>.unmodifiable(
      arrows,
    );
  }

  bool contains(Arrow arrow) {
    return arrows.contains(arrow);
  }

  int indexOf(Arrow arrow) {
    return arrows.indexOf(arrow);
  }

  ReverseSolutionPlan copy() {
    return ReverseSolutionPlan(
      arrows: List<Arrow>.from(arrows),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is! ReverseSolutionPlan) {
      return false;
    }

    if (other.arrows.length != arrows.length) {
      return false;
    }

    for (var index = 0;
        index < arrows.length;
        index++) {
      if (other.arrows[index] != arrows[index]) {
        return false;
      }
    }

    return true;
  }

  @override
  int get hashCode {
    var result = 17;

    for (final arrow in arrows) {
      result = 31 * result + arrow.hashCode;
    }

    return result;
  }

  @override
  String toString() {
    return 'ReverseSolutionPlan('
        'length: ${arrows.length}'
        ')';
  }
}