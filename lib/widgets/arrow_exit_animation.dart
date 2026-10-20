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
  const _ArrowExitPainter({
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
    final points = _buildPath();

    if (points.length < 2) {
      return;
    }

    final occupiedLength = _occupiedLength(points);

    final boardExitLength = step * 0.75;

    final headDistance =
        occupiedLength +
        boardExitLength * progress;

    final snakeLength = math.max(
      cellSize * 0.9,
      occupiedLength,
    );

    final tailDistance =
        headDistance - snakeLength;

    final visiblePoints = _visiblePoints(
      points,
      tailDistance,
      headDistance,
    );

    if (visiblePoints.length < 2) {
      return;
    }

    _drawSnake(
      canvas,
      visiblePoints,
    );

    _drawHead(
      canvas,
      visiblePoints.last.position,
      visiblePoints.last.direction,
    );
  }

  List<_PathPoint> _buildPath() {
    final points = <_PathPoint>[];

    var x = cellSize / 2;
    var y = cellSize / 2;

    points.add(
      _PathPoint(
        position: Offset(x, y),
        direction: arrow.direction,
      ),
    );

    if (arrow.isBent) {
      for (final direction in arrow.path) {
        final offset = _directionOffset(
          direction,
          step,
        );

        x += offset.dx;
        y += offset.dy;

        points.add(
          _PathPoint(
            position: Offset(x, y),
            direction: direction,
          ),
        );
      }
    } else {
      for (var i = 1; i < arrow.length; i++) {
        final offset = _directionOffset(
          arrow.direction,
          step,
        );

        x += offset.dx;
        y += offset.dy;

        points.add(
          _PathPoint(
            position: Offset(x, y),
            direction: arrow.direction,
          ),
        );
      }
    }

    final exitDirection = arrow.exitDirection;

    final edgeDistance = _distanceToBoardEdge(
      x,
      y,
      exitDirection,
      size: null,
    );

    final exitSteps = math.max(
      1,
      (edgeDistance / step).ceil(),
    );

    for (var i = 0; i < exitSteps; i++) {
      final offset = _directionOffset(
        exitDirection,
        step,
      );

      x += offset.dx;
      y += offset.dy;

      points.add(
        _PathPoint(
          position: Offset(x, y),
          direction: exitDirection,
        ),
      );
    }

    return points;
  }

  double _occupiedLength(
    List<_PathPoint> points,
  ) {
    if (points.length < 2) {
      return 0;
    }

    var length = 0.0;

    final occupiedPoints = arrow.isBent
        ? arrow.path.length + 1
        : arrow.length;

    final end =
        math.min(
          occupiedPoints,
          points.length,
        );

    for (var i = 1; i < end; i++) {
      length +=
          (points[i].position -
                  points[i - 1].position)
              .distance;
    }

    return length;
  }

  double _distanceToBoardEdge(
    double x,
    double y,
    ArrowDirection direction, {
    required Size? size,
  }) {
    // The animation is positioned relative to the arrow's
    // starting grid cell. The arrow only needs a short
    // movement beyond its final cell before disappearing.
    return step * 1.2;
  }

  List<_PathPoint> _visiblePoints(
    List<_PathPoint> points,
    double start,
    double end,
  ) {
    final totalLength = _pathLength(points);

    final actualStart = start.clamp(
      0.0,
      totalLength,
    );

    final actualEnd = end.clamp(
      0.0,
      totalLength,
    );

    if (actualEnd <= actualStart) {
      return [];
    }

    final result = <_PathPoint>[
      _pointAt(
        points,
        actualStart,
      ),
    ];

    var distance = 0.0;

    for (var i = 1; i < points.length; i++) {
      final segmentLength =
          (points[i].position -
                  points[i - 1].position)
              .distance;

      final nextDistance =
          distance + segmentLength;

      if (nextDistance > actualStart &&
          nextDistance < actualEnd) {
        result.add(points[i]);
      }

      distance = nextDistance;
    }

    result.add(
      _pointAt(
        points,
        actualEnd,
      ),
    );

    return result;
  }

  _PathPoint _pointAt(
    List<_PathPoint> points,
    double distance,
  ) {
    if (distance <= 0) {
      return points.first;
    }

    final totalLength = _pathLength(points);

    if (distance >= totalLength) {
      return points.last;
    }

    var travelled = 0.0;

    for (var i = 1; i < points.length; i++) {
      final start = points[i - 1];
      final end = points[i];

      final segmentLength =
          (end.position -
                  start.position)
              .distance;

      if (travelled + segmentLength >= distance) {
        final amount =
            (distance - travelled) /
                segmentLength;

        return _PathPoint(
          position: Offset.lerp(
            start.position,
            end.position,
            amount,
          )!,
          direction: end.direction,
        );
      }

      travelled += segmentLength;
    }

    return points.last;
  }

  double _pathLength(
    List<_PathPoint> points,
  ) {
    var length = 0.0;

    for (var i = 1; i < points.length; i++) {
      length +=
          (points[i].position -
                  points[i - 1].position)
              .distance;
    }

    return length;
  }

  void _drawSnake(
    Canvas canvas,
    List<_PathPoint> points,
  ) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = math.max(
        7.0,
        cellSize * 0.18,
      )
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();

    path.moveTo(
      points.first.position.dx,
      points.first.position.dy,
    );

    for (var i = 1; i < points.length; i++) {
      path.lineTo(
        points[i].position.dx,
        points[i].position.dy,
      );
    }

    canvas.drawPath(
      path,
      paint,
    );
  }

  void _drawHead(
    Canvas canvas,
    Offset tip,
    ArrowDirection direction,
  ) {
    final headSize = math.min(
      cellSize * 0.32,
      18.0,
    );

    final side = _perpendicular(
      direction,
    );

    final sideOffset = _directionOffset(
      side,
      headSize,
    );

    final left = tip - sideOffset;
    final right = tip + sideOffset;

    final head = Path()
      ..moveTo(
        tip.dx,
        tip.dy,
      )
      ..lineTo(
        left.dx,
        left.dy,
      )
      ..lineTo(
        right.dx,
        right.dy,
      )
      ..close();

    canvas.drawPath(
      head,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  Offset _directionOffset(
    ArrowDirection direction,
    double distance,
  ) {
    switch (direction) {
      case ArrowDirection.up:
        return Offset(
          0,
          -distance,
        );

      case ArrowDirection.right:
        return Offset(
          distance,
          0,
        );

      case ArrowDirection.down:
        return Offset(
          0,
          distance,
        );

      case ArrowDirection.left:
        return Offset(
          -distance,
          0,
        );
    }
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