import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../game/arrow.dart';

class ArrowExitAnimation extends StatelessWidget {
  const ArrowExitAnimation({
    super.key,
    required this.arrow,
    required this.progress,
    required this.cellSize,
    required this.spacing,
    this.color = Colors.green,
  });

  final Arrow arrow;
  final double progress;
  final double cellSize;
  final double spacing;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ArrowExitPainter(
        arrow: arrow,
        progress: progress,
        cellSize: cellSize,
        spacing: spacing,
        color: color,
      ),
      size: Size.infinite,
    );
  }
}

class _ArrowExitPainter extends CustomPainter {
  _ArrowExitPainter({
    required this.arrow,
    required this.progress,
    required this.cellSize,
    required this.spacing,
    required this.color,
  });

  final Arrow arrow;
  final double progress;
  final double cellSize;
  final double spacing;
  final Color color;

  double get step => cellSize + spacing;

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    if (arrow.isBent) {
      _paintBentArrow(canvas);
      return;
    }

    _paintStraightArrow(canvas);
  }

  void _paintStraightArrow(Canvas canvas) {
    final count = arrow.length;

    final headTravel = step * 1.4 * progress;

    for (var i = 0; i < count; i++) {
      final lag = i * step;
      final distance = headTravel - lag;

      final center = _baseCenter(i) +
          _directionOffset(
            arrow.direction,
            distance,
          );

      _drawSegment(
        canvas,
        center,
        i == 0,
      );
    }
  }

  void _paintBentArrow(Canvas canvas) {
    final points = _bentPoints();

    if (points.isEmpty) {
      return;
    }

    final headDistance =
        _pathLength(points) * 0.45 * progress;

    for (var i = 0; i < points.length; i++) {
      final distance =
          headDistance - i * step;

      final point = _pointAlongPath(
        points,
        distance,
      );

      if (point == null) {
        continue;
      }

      _drawSegment(
        canvas,
        point.position,
        i == 0,
        direction: point.direction,
      );
    }
  }

  Offset _baseCenter(int index) {
    switch (arrow.direction) {
      case ArrowDirection.up:
        return Offset(
          cellSize / 2,
          cellSize / 2 + index * step,
        );

      case ArrowDirection.right:
        return Offset(
          cellSize / 2 + index * step,
          cellSize / 2,
        );

      case ArrowDirection.down:
        return Offset(
          cellSize / 2,
          cellSize / 2 + index * step,
        );

      case ArrowDirection.left:
        return Offset(
          cellSize / 2 + index * step,
          cellSize / 2,
        );
    }
  }

  List<_PathPoint> _bentPoints() {
    final points = <_PathPoint>[
      _PathPoint(
        position: Offset(
          cellSize / 2,
          cellSize / 2,
        ),
        direction: arrow.direction,
      ),
    ];

    var x = cellSize / 2;
    var y = cellSize / 2;

    for (final direction in arrow.path!) {
      switch (direction) {
        case ArrowDirection.up:
          y -= step;
          break;
        case ArrowDirection.right:
          x += step;
          break;
        case ArrowDirection.down:
          y += step;
          break;
        case ArrowDirection.left:
          x -= step;
          break;
      }

      points.add(
        _PathPoint(
          position: Offset(x, y),
          direction: direction,
        ),
      );
    }

    return points;
  }

  double _pathLength(
    List<_PathPoint> points,
  ) {
    if (points.length < 2) {
      return 0;
    }

    return (points.length - 1) * step;
  }

  _PathPoint? _pointAlongPath(
    List<_PathPoint> points,
    double distance,
  ) {
    if (points.isEmpty) {
      return null;
    }

    if (distance <= 0) {
      return points.first;
    }

    final maxDistance =
        (points.length - 1) * step;

    if (distance >= maxDistance) {
      return points.last;
    }

    final segment = distance / step;
    final index = segment.floor();
    final local = segment - index;

    final start = points[index];
    final end = points[index + 1];

    return _PathPoint(
      position: Offset.lerp(
        start.position,
        end.position,
        local,
      )!,
      direction: end.direction,
    );
  }

  Offset _directionOffset(
    ArrowDirection direction,
    double distance,
  ) {
    switch (direction) {
      case ArrowDirection.up:
        return Offset(0, -distance);

      case ArrowDirection.right:
        return Offset(distance, 0);

      case ArrowDirection.down:
        return Offset(0, distance);

      case ArrowDirection.left:
        return Offset(-distance, 0);
    }
  }

  void _drawSegment(
    Canvas canvas,
    Offset center,
    bool isHead, {
    ArrowDirection? direction,
  }) {
    final actualDirection =
        direction ?? arrow.direction;

    final shaftWidth =
        math.max(4.0, cellSize * 0.10);

    final headSize =
        math.min(cellSize * 0.28, 14.0);

    final paint = Paint()
      ..color = color
      ..strokeWidth = shaftWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    if (!isHead) {
      final start = center -
          _directionOffset(
            actualDirection,
            cellSize * 0.30,
          );

      final end = center +
          _directionOffset(
            actualDirection,
            cellSize * 0.30,
          );

      canvas.drawLine(
        start,
        end,
        paint,
      );

      return;
    }

    final shaftStart = center -
        _directionOffset(
          actualDirection,
          cellSize * 0.28,
        );

    final shaftEnd = center +
        _directionOffset(
          actualDirection,
          cellSize * 0.10,
        );

    canvas.drawLine(
      shaftStart,
      shaftEnd,
      paint,
    );

    final head = Path();

    final tip = center +
        _directionOffset(
          actualDirection,
          cellSize * 0.30,
        );

    final sideDirection =
        _perpendicular(actualDirection);

    final left = tip -
        _directionOffset(
          sideDirection,
          headSize,
        );

    final right = tip +
        _directionOffset(
          sideDirection,
          headSize,
        );

    head
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(left.dx, left.dy)
      ..lineTo(right.dx, right.dy)
      ..close();

    canvas.drawPath(
      head,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  ArrowDirection _perpendicular(
    ArrowDirection direction,
  ) {
    switch (direction) {
      case ArrowDirection.up:
      case ArrowDirection.down:
        return ArrowDirection.right;

      case ArrowDirection.left:
      case ArrowDirection.right:
        return ArrowDirection.down;
    }
  }

  @override
  bool shouldRepaint(
    _ArrowExitPainter oldDelegate,
  ) {
    return oldDelegate.progress != progress ||
        oldDelegate.arrow != arrow ||
        oldDelegate.cellSize != cellSize ||
        oldDelegate.spacing != spacing ||
        oldDelegate.color != color;
  }
}

class _PathPoint {
  const _PathPoint({
    required this.position,
    required this.direction,
  });

  final Offset position;
  final ArrowDirection direction;
}