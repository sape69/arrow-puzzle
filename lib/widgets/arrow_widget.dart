import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../game/arrow.dart';

class ArrowWidget extends StatelessWidget {
  const ArrowWidget({
    super.key,
    required this.arrow,
    required this.cellSize,
    this.spacing = 4.0,
    this.color = Colors.white,
  });

  final Arrow arrow;
  final double cellSize;
  final double spacing;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (arrow.isBent) {
      return _buildBentArrow();
    }

    return _buildStraightArrow();
  }

  Widget _buildStraightArrow() {
    final iconSize = math.min(
      cellSize * 0.55,
      36.0,
    );

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
    return CustomPaint(
      painter: _BentArrowPainter(
        path: arrow.path,
        cellSize: cellSize,
        spacing: spacing,
        color: color,
      ),
      size: Size.infinite,
    );
  }
}

class _BentArrowPainter extends CustomPainter {
  const _BentArrowPainter({
    required this.path,
    required this.cellSize,
    required this.spacing,
    required this.color,
  });

  final List<ArrowDirection> path;
  final double cellSize;
  final double spacing;
  final Color color;

  double get step => cellSize + spacing;

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    if (path.isEmpty) {
      return;
    }

    final bounds = _calculateBounds();

    var column = -bounds.minColumn;
    var row = -bounds.minRow;

    final points = <_Point>[
      _Point(
        row: row,
        column: column,
      ),
    ];

    for (final direction in path) {
      switch (direction) {
        case ArrowDirection.up:
          row--;
          break;

        case ArrowDirection.right:
          column++;
          break;

        case ArrowDirection.down:
          row++;
          break;

        case ArrowDirection.left:
          column--;
          break;
      }

      points.add(
        _Point(
          row: row,
          column: column,
        ),
      );
    }

    final pathPainter = Path();

    final first = _cellCenter(
      points.first,
    );

    pathPainter.moveTo(
      first.dx,
      first.dy,
    );

    for (var i = 1; i < points.length; i++) {
      final point = _cellCenter(
        points[i],
      );

      pathPainter.lineTo(
        point.dx,
        point.dy,
      );
    }

    final paint = Paint()
      ..color = color
      ..strokeWidth = math.max(
        6.0,
        cellSize * 0.12,
      )
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(
      pathPainter,
      paint,
    );

    final lastPoint = _cellCenter(
      points.last,
    );

    _drawArrowHead(
      canvas,
      lastPoint,
      path.last,
    );
  }

  _Bounds _calculateBounds() {
    var row = 0;
    var column = 0;

    var minRow = 0;
    var maxRow = 0;
    var minColumn = 0;
    var maxColumn = 0;

    for (final direction in path) {
      switch (direction) {
        case ArrowDirection.up:
          row--;
          break;

        case ArrowDirection.right:
          column++;
          break;

        case ArrowDirection.down:
          row++;
          break;

        case ArrowDirection.left:
          column--;
          break;
      }

      minRow = math.min(
        minRow,
        row,
      );

      maxRow = math.max(
        maxRow,
        row,
      );

      minColumn = math.min(
        minColumn,
        column,
      );

      maxColumn = math.max(
        maxColumn,
        column,
      );
    }

    return _Bounds(
      minRow: minRow,
      maxRow: maxRow,
      minColumn: minColumn,
      maxColumn: maxColumn,
    );
  }

  Offset _cellCenter(
    _Point point,
  ) {
    return Offset(
      (point.column * step) +
          (cellSize / 2),
      (point.row * step) +
          (cellSize / 2),
    );
  }

  void _drawArrowHead(
    Canvas canvas,
    Offset point,
    ArrowDirection direction,
  ) {
    final headSize = math.min(
      cellSize * 0.22,
      12.0,
    );

    final side = _perpendicular(
      direction,
    );

    final sideOffset = _directionOffset(
      side,
      headSize,
    );

    final backOffset = _directionOffset(
      direction,
      headSize,
    );

    final left =
        point -
        sideOffset -
        backOffset;

    final right =
        point +
        sideOffset -
        backOffset;

    final head = Path()
      ..moveTo(
        point.dx,
        point.dy,
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
    _BentArrowPainter oldDelegate,
  ) {
    return oldDelegate.path != path ||
        oldDelegate.cellSize != cellSize ||
        oldDelegate.spacing != spacing ||
        oldDelegate.color != color;
  }
}

class _Point {
  const _Point({
    required this.row,
    required this.column,
  });

  final int row;
  final int column;
}

class _Bounds {
  const _Bounds({
    required this.minRow,
    required this.maxRow,
    required this.minColumn,
    required this.maxColumn,
  });

  final int minRow;
  final int maxRow;
  final int minColumn;
  final int maxColumn;
}