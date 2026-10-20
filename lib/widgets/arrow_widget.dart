import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../game/arrow.dart';

class ArrowWidget extends StatelessWidget {
  const ArrowWidget({
    super.key,
    required this.arrow,
    required this.cellSize,
    this.color = Colors.white,
  });

  final Arrow arrow;
  final double cellSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (arrow.isBent) {
      return _buildBentArrow();
    }

    return _buildStraightArrow();
  }

  Widget _buildStraightArrow() {
    final iconSize = math.min(cellSize * 0.55, 36.0);

    final icon = Icon(
      Icons.arrow_forward,
      size: iconSize,
      color: color,
    );

    switch (arrow.direction) {
      case ArrowDirection.right:
        return icon;

      case ArrowDirection.left:
        return Transform.rotate(
          angle: math.pi,
          child: icon,
        );

      case ArrowDirection.up:
        return Transform.rotate(
          angle: -math.pi / 2,
          child: icon,
        );

      case ArrowDirection.down:
        return Transform.rotate(
          angle: math.pi / 2,
          child: icon,
        );
    }
  }

  Widget _buildBentArrow() {
    final directions = arrow.path!;

    return CustomPaint(
      painter: _BentArrowPainter(
        directions: directions,
        color: color,
      ),
      size: Size(
        cellSize,
        cellSize,
      ),
    );
  }
}

class _BentArrowPainter extends CustomPainter {
  _BentArrowPainter({
    required this.directions,
    required this.color,
  });

  final List<ArrowDirection> directions;
  final Color color;

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(
        center.dx,
        center.dy,
      );

    var current = center;

    for (final direction in directions) {
      final next = _nextPoint(
        current,
        direction,
        size,
      );

      path.lineTo(
        next.dx,
        next.dy,
      );

      current = next;
    }

    canvas.drawPath(
      path,
      paint,
    );

    _drawArrowHead(
      canvas,
      current,
      directions.last,
      size,
    );
  }

  Offset _nextPoint(
    Offset current,
    ArrowDirection direction,
    Size size,
  ) {
    final distance = size.width * 0.45;

    switch (direction) {
      case ArrowDirection.up:
        return current.translate(
          0,
          -distance,
        );

      case ArrowDirection.right:
        return current.translate(
          distance,
          0,
        );

      case ArrowDirection.down:
        return current.translate(
          0,
          distance,
        );

      case ArrowDirection.left:
        return current.translate(
          -distance,
          0,
        );
    }
  }

  void _drawArrowHead(
    Canvas canvas,
    Offset point,
    ArrowDirection direction,
    Size size,
  ) {
    final headSize = size.width * 0.18;

    final path = Path();

    switch (direction) {
      case ArrowDirection.up:
        path
          ..moveTo(
            point.dx,
            point.dy - headSize,
          )
          ..lineTo(
            point.dx - headSize,
            point.dy + headSize,
          )
          ..lineTo(
            point.dx + headSize,
            point.dy + headSize,
          );

      case ArrowDirection.right:
        path
          ..moveTo(
            point.dx + headSize,
            point.dy,
          )
          ..lineTo(
            point.dx - headSize,
            point.dy - headSize,
          )
          ..lineTo(
            point.dx - headSize,
            point.dy + headSize,
          );

      case ArrowDirection.down:
        path
          ..moveTo(
            point.dx,
            point.dy + headSize,
          )
          ..lineTo(
            point.dx - headSize,
            point.dy - headSize,
          )
          ..lineTo(
            point.dx + headSize,
            point.dy - headSize,
          );

      case ArrowDirection.left:
        path
          ..moveTo(
            point.dx - headSize,
            point.dy,
          )
          ..lineTo(
            point.dx + headSize,
            point.dy - headSize,
          )
          ..lineTo(
            point.dx + headSize,
            point.dy + headSize,
          );
    }

    path.close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(
      path,
      paint,
    );
  }

  @override
  bool shouldRepaint(
    _BentArrowPainter oldDelegate,
  ) {
    return oldDelegate.directions != directions ||
        oldDelegate.color != color;
  }
}