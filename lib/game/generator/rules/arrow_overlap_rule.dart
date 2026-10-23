import '../../arrow.dart';
import '../geometry/arrow_collision.dart';

class ArrowOverlapRule {
  const ArrowOverlapRule({
    ArrowCollision collision = const ArrowCollision(),
  }) : _collision = collision;

  final ArrowCollision _collision;

  bool canPlace(
    Arrow candidate,
    List<Arrow> existing,
  ) {
    return _collision.canPlace(
      candidate,
      existing,
    );
  }

  bool overlaps(
    Arrow first,
    Arrow second,
  ) {
    return _collision.overlaps(
      first,
      second,
    );
  }

  List<Arrow> findOverlaps(
    Arrow candidate,
    List<Arrow> existing,
  ) {
    return _collision.findCollisions(
      candidate,
      existing,
    );
  }

  bool allValid(
    List<Arrow> arrows,
  ) {
    return _collision.allNonOverlapping(
      arrows,
    );
  }
}