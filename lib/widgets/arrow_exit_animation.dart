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
    final positions = _positions();

    if (positions.isEmpty) {
      return;
    }

    for (var i = 0; i < positions.length; i++) {
      final delay = (positions.length - 1 - i) * 0.12;

      final localProgress = _delayedProgress(
        progress,
        delay,
      );

      final offset = _movement(
        positions[i],
        localProgress,
      );

      _drawSegment(
        canvas,
        positions[i] + offset,
        i == positions.length - 1,
      );
    }
  }

  List<Offset> _positions() {
    if (!arrow.isBent) {
      return _straightPositions();
    }

    return _bentPositions();
  }

  List<Offset> _straightPositions() {
    final positions = <Offset>[];

    for (var i = 0; i < arrow.length; i++) {
      var dx = 0.0;
      var dy = 0.0;

      switch (arrow.direction) {
        case ArrowDirection.up:
          dy = -i * step;
          break;
        case ArrowDirection.right:
          dx = i * step;
          break;
        case ArrowDirection.down:
          dy = i * step;
          break;
        case ArrowDirection.left:
          dx = -i * step;
          break;
      }

      positions.add(
        Offset(
          dx + cellSize / 2,
          dy + cellSize / 2,
        ),
      );
    }

    return positions;
  }

  List<Offset> _bentPositions() {
    final positions = <Offset>[
      Offset(
        cellSize / 2,
        cellSize / 2,
      ),
    ];

    var dx = 0.0;
    var dy = 0.0;

    for (final direction in arrow.path!) {
      switch (direction) {
        case ArrowDirection.up:
          dy -= step;
          break;
        case ArrowDirection.right:
          dx += step;
          break;
        case ArrowDirection.down:
          dy += step;
          break;
        case ArrowDirection.left:
          dx -= step;
          break;
      }

      positions.add(
        Offset(
          dx + cellSize / 2,
          dy + cellSize / 2,
        ),
      );
    }

    return positions;
  }

  double _delayedProgress(
    double value,
    double delay,
  ) {
    if (value <= delay) {
      return 0;
    }

    return ((value - delay) / (1 - delay))
        .clamp(0.0, 1.0);
  }

  Offset _movement(
    Offset position,
    double value,
  ) {
    final distance = step * value;

    if (arrow.isBent) {
      final direction = _directionForSegment(
        position,
      );

      return _directionOffset(
        direction,
        distance,
      );
    }

    return _directionOffset(
      arrow.direction,
      distance,
    );
  }

  ArrowDirection _directionForSegment(
    Offset position,
  ) {
    final path = arrow.path!;

    if (path.isEmpty) {
      return arrow.direction;
    }

    var closestIndex = 0;
    var closestDistance = double.infinity;

    for (var i = 0; i < path.length; i++) {
      final direction = path[i];

      final distance = _distanceToDirection(
        position,
        direction,
      );

      if (distance < closestDistance) {
        closestDistance = distance;
        closestIndex = i;
      }
    }

    return path[
      math.min(
        closestIndex,
        path.length - 1,
      )
    ];
  }

  double _distanceToDirection(
    Offset position,
    ArrowDirection direction,
  ) {
    switch (direction) {
      case ArrowDirection.up:
        return position.dy.abs();
      case ArrowDirection.right:
        return position.dx.abs();
      case ArrowDirection.down:
        return position.dy.abs();
      case ArrowDirection.left:
        return position.dx.abs();
    }
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
    bool isHead,
  ) {
    final iconSize = math.min(
      cellSize * 0.55,
      36.0,
    );

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      center,
      iconSize * 0.22,
      paint,
    );

    if (isHead) {
      _drawHead(
        canvas,
        center,
      );
    }
  }

  void _drawHead(
    Canvas canvas,
    Offset center,
  ) {
    final size = cellSize * 0.20;

    final path = Path();

    switch (arrow.direction) {
      case ArrowDirection.up:
        path
          ..moveTo(
            center.dx,
            center.dy - size * 2,
          )
          ..lineTo(
            center.dx - size,
            center.dy,
          )
          ..lineTo(
            center.dx + size,
            center.dy,
          );
        break;

      case ArrowDirection.right:
        path
          ..moveTo(
            center.dx + size * 2,
            center.dy,
          )
          ..lineTo(
            center.dx,
            center.dy - size,
          )
          ..lineTo(
            center.dx,
            center.dy + size,
          );
        break;

      case ArrowDirection.down:
        path
          ..moveTo(
            center.dx,
            center.dy + size * 2,
          )
          ..lineTo(
            center.dx - size,
            center.dy,
          )
          ..lineTo(
            center.dx + size,
            center.dy,
          );
        break;

      case ArrowDirection.left:
        path
          ..moveTo(
            center.dx - size * 2,
            center.dy,
          )
          ..lineTo(
            center.dx,
            center.dy - size,
          )
          ..lineTo(
            center.dx,
            center.dy + size,
          );
        break;
    }

    path.close();
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
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