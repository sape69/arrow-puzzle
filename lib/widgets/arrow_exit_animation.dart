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
    final points = _createPath();

    if (points.length < 2) {
      _drawSingleArrow(
        canvas,
        points.isEmpty
            ? Offset(
                size.width / 2,
                size.height / 2,
              )
            : points.first.position,
        arrow.direction,
      );
      return;
    }

    final totalPathLength = _pathLength(points);

    final snakeLength = math.max(
      cellSize * 0.65,
      (arrow.segmentCount - 1) * step +
          cellSize * 0.45,
    );

    final extraExitDistance =
        math.max(size.width, size.height) +
        cellSize * 2;

    final headDistance =
        totalPathLength +
        extraExitDistance * progress;

    final tailDistance =
        headDistance - snakeLength;

    final visiblePoints = _extractPath(
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
  }

  List<_PathPoint> _createPath() {
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
      for (final direction in arrow.path!) {
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

      _extendPath(
        points,
        arrow.path!.last,
      );

      return points;
    }

    for (var i = 1; i < arrow.length + 3; i++) {
      final offset = _directionOffset(
        arrow.direction,
        step,
      );

      x += offset.dx;
      y += offset.dy;

      points.add(
        _PathPoint(
          position: Offset(
            x,
            y,
          ),
          direction: arrow.direction,
        ),
      );
    }

    return points;
  }

  void _extendPath(
    List<_PathPoint> points,
    ArrowDirection direction,
  ) {
    var position = points.last.position;

    for (var i = 0; i < 4; i++) {
      final offset = _directionOffset(
        direction,
        step,
      );

      position += offset;

      points.add(
        _PathPoint(
          position: position,
          direction: direction,
        ),
      );
    }
  }

  List<_PathPoint> _extractPath(
    List<_PathPoint> points,
    double start,
    double end,
  ) {
    final result = <_PathPoint>[];

    final total = _pathLength(points);

    final actualStart = start.clamp(
      0.0,
      total,
    );

    final actualEnd = end.clamp(
      0.0,
      total,
    );

    if (actualEnd <= actualStart) {
      return result;
    }

    result.add(
      _pointAtDistance(
        points,
        actualStart,
      ),
    );

    for (var i = 1; i < points.length; i++) {
      final distance = _distanceToPoint(
        points,
        i,
      );

      if (distance > actualStart &&
          distance < actualEnd) {
        result.add(points[i]);
      }
    }

    result.add(
      _pointAtDistance(
        points,
        actualEnd,
      ),
    );

    return result;
  }

  _PathPoint _pointAtDistance(
    List<_PathPoint> points,
    double distance,
  ) {
    if (distance <= 0) {
      return points.first;
    }

    final total = _pathLength(points);

    if (distance >= total) {
      return points.last;
    }

    var accumulated = 0.0;

    for (var i = 1; i < points.length; i++) {
      final start = points[i - 1];
      final end = points[i];

      final segmentLength =
          (end.position - start.position).distance;

      if (accumulated + segmentLength >= distance) {
        final local =
            (distance - accumulated) /
                segmentLength;

        return _PathPoint(
          position: Offset.lerp(
            start.position,
            end.position,
            local,
          )!,
          direction: end.direction,
        );
      }

      accumulated += segmentLength;
    }

    return points.last;
  }

  double _distanceToPoint(
    List<_PathPoint> points,
    int index,
  ) {
    var distance = 0.0;

    for (var i = 1; i <= index; i++) {
      distance +=
          (points[i].position -
                  points[i - 1].position)
              .distance;
    }

    return distance;
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
    final shaftWidth =
        math.max(4.0, cellSize * 0.10);

    final paint = Paint()
      ..color = color
      ..strokeWidth = shaftWidth
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

    final head = points.last;

    _drawArrowHead(
      canvas,
      head.position,
      head.direction,
    );
  }

  void _drawSingleArrow(
    Canvas canvas,
    Offset center,
    ArrowDirection direction,
  ) {
    final paint = Paint()
      ..color = color
      ..strokeWidth =
          math.max(4.0, cellSize * 0.10)
      ..strokeCap = StrokeCap.round;

    final shaftStart =
        center -
        _directionOffset(
          direction,
          cellSize * 0.22,
        );

    final shaftEnd =
        center +
        _directionOffset(
          direction,
          cellSize * 0.10,
        );

    canvas.drawLine(
      shaftStart,
      shaftEnd,
      paint,
    );

    _drawArrowHead(
      canvas,
      center +
          _directionOffset(
            direction,
            cellSize * 0.28,
          ),
      direction,
    );
  }

  void _drawArrowHead(
    Canvas canvas,
    Offset tip,
    ArrowDirection direction,
  ) {
    final size =
        math.min(
          cellSize * 0.28,
          14.0,
        );

    final side =
        _perpendicular(direction);

    final left =
        tip -
        _directionOffset(
          side,
          size,
        );

    final right =
        tip +
        _directionOffset(
          side,
          size,
        );

    final path = Path()
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
      path,
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