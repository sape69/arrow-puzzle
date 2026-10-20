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
      painter: _SnakeArrowPainter(
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

class _SnakeArrowPainter extends CustomPainter {
  _SnakeArrowPainter({
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
    final path = _createPath();

    if (path.length < 2) {
      _drawArrow(
        canvas,
        path.isEmpty
            ? Offset(
                size.width / 2,
                size.height / 2,
              )
            : path.first.position,
        arrow.direction,
      );
      return;
    }

    final snakeLength = _snakeLength(path);

    final totalLength = _pathLength(path);

    final exitDistance =
        math.max(size.width, size.height) +
        step * 2;

    final travel =
        exitDistance * progress;

    final startDistance = travel;
    final endDistance =
        travel + snakeLength;

    final visiblePath = _extractPath(
      path,
      startDistance,
      endDistance,
    );

    if (visiblePath.length < 2) {
      return;
    }

    _drawSnake(
      canvas,
      visiblePath,
    );

    if (endDistance >= totalLength) {
      final head = visiblePath.last;

      _drawArrowHead(
        canvas,
        head.position,
        head.direction,
      );
    }
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

    for (var i = 0; i < arrow.length + 3; i++) {
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

    return points;
  }

  void _extendPath(
    List<_PathPoint> points,
    ArrowDirection direction,
  ) {
    var position = points.last.position;

    for (var i = 0; i < 5; i++) {
      position += _directionOffset(
        direction,
        step,
      );

      points.add(
        _PathPoint(
          position: position,
          direction: direction,
        ),
      );
    }
  }

  double _snakeLength(
    List<_PathPoint> path,
  ) {
    if (arrow.isBent) {
      return math.max(
        step,
        (arrow.segmentCount) * step,
      );
    }

    return math.max(
      step,
      arrow.length * step,
    );
  }

  List<_PathPoint> _extractPath(
    List<_PathPoint> path,
    double start,
    double end,
  ) {
    final total = _pathLength(path);

    if (start >= total) {
      return [];
    }

    final actualStart =
        start.clamp(0.0, total);

    final actualEnd =
        end.clamp(0.0, total);

    if (actualEnd <= actualStart) {
      return [];
    }

    final result = <_PathPoint>[];

    result.add(
      _pointAtDistance(
        path,
        actualStart,
      ),
    );

    var distance = 0.0;

    for (var i = 1; i < path.length; i++) {
      final segmentLength =
          (path[i].position -
                  path[i - 1].position)
              .distance;

      final nextDistance =
          distance + segmentLength;

      if (nextDistance > actualStart &&
          nextDistance < actualEnd) {
        result.add(path[i]);
      }

      distance = nextDistance;
    }

    result.add(
      _pointAtDistance(
        path,
        actualEnd,
      ),
    );

    return result;
  }

  _PathPoint _pointAtDistance(
    List<_PathPoint> path,
    double distance,
  ) {
    if (distance <= 0) {
      return path.first;
    }

    final total = _pathLength(path);

    if (distance >= total) {
      return path.last;
    }

    var travelled = 0.0;

    for (var i = 1; i < path.length; i++) {
      final start = path[i - 1];
      final end = path[i];

      final segmentLength =
          (end.position -
                  start.position)
              .distance;

      if (travelled + segmentLength >=
          distance) {
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

    return path.last;
  }

  double _pathLength(
    List<_PathPoint> path,
  ) {
    var length = 0.0;

    for (var i = 1; i < path.length; i++) {
      length +=
          (path[i].position -
                  path[i - 1].position)
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
      ..strokeWidth =
          math.max(
            5.0,
            cellSize * 0.11,
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

  void _drawArrow(
    Canvas canvas,
    Offset center,
    ArrowDirection direction,
  ) {
    final paint = Paint()
      ..color = color
      ..strokeWidth =
          math.max(
            5.0,
            cellSize * 0.11,
          )
      ..strokeCap = StrokeCap.round;

    final start =
        center -
        _directionOffset(
          direction,
          cellSize * 0.20,
        );

    final end =
        center +
        _directionOffset(
          direction,
          cellSize * 0.12,
        );

    canvas.drawLine(
      start,
      end,
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
    final headSize =
        math.min(
          cellSize * 0.30,
          15.0,
        );

    final side =
        _perpendicular(direction);

    final left =
        tip -
        _directionOffset(
          side,
          headSize,
        );

    final right =
        tip +
        _directionOffset(
          side,
          headSize,
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
        return Offset(0, -distance);

      case ArrowDirection.right:
        return Offset(distance, 0);

      case ArrowDirection.down:
        return Offset(0, distance);

      case ArrowDirection.left:
        return Offset(-distance, 0);
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
    _SnakeArrowPainter oldDelegate,
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