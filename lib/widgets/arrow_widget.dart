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
    return CustomPaint(
      painter: _StraightArrowPainter(
        direction: arrow.direction,
        length: arrow.length,
        cellSize: cellSize,
        spacing: spacing,
        color: color,
      ),
      size: Size.infinite,
    );
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

class _StraightArrowPainter extends CustomPainter {
  const _StraightArrowPainter({
    required this.direction,
    required this.length,
    required this.cellSize,
    required this.spacing,
    required this.color,
  });

  final ArrowDirection direction;
  final int length;
  final double cellSize;
  final double spacing;
  final Color color;

  double get step => cellSize + spacing;

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    if (length <= 0) {
      return;
    }

    final center = cellSize / 2;

    final tip = _pointAt(
      center,
      center,
      length - 1,
    );

    final headLength = math.min(
      cellSize * 0.28,
      14.0,
    );

    final headWidth = math.min(
      cellSize * 0.18,
      9.0,
    );

    final directionVector =
        _unitVector(direction);

    Offset start;

    if (length == 1) {
      start = tip -
          directionVector *
              (cellSize * 0.16);
    } else {
      start = _pointAt(
        center,
        center,
        0,
      );
    }

    final shaftEnd =
        tip -
        directionVector *
            (headLength * 0.65);

    final paint = Paint()
      ..color = color
      ..strokeWidth = math.max(
        4.0,
        cellSize * 0.075,
      )
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      start,
      shaftEnd,
      paint,
    );

    _drawArrowHead(
      canvas,
      tip,
      headLength,
      headWidth,
    );
  }

  Offset _pointAt(
    double x,
    double y,
    int distance,
  ) {
    return Offset(
      x + _directionVectorX(
            direction,
          ) *
          distance *
          step,
      y + _directionVectorY(
            direction,
          ) *
          distance *
          step,
    );
  }

  Offset _unitVector(
    ArrowDirection direction,
  ) {
    return Offset(
      _directionVectorX(direction),
      _directionVectorY(direction),
    );
  }

  double _directionVectorX(
    ArrowDirection direction,
  ) {
    switch (direction) {
      case ArrowDirection.left:
        return -1;
      case ArrowDirection.right:
        return 1;
      case ArrowDirection.up:
      case ArrowDirection.down:
        return 0;
    }
  }

  double _directionVectorY(
    ArrowDirection direction,
  ) {
    switch (direction) {
      case ArrowDirection.up:
        return -1;
      case ArrowDirection.down:
        return 1;
      case ArrowDirection.left:
      case ArrowDirection.right:
        return 0;
    }
  }

  void _drawArrowHead(
    Canvas canvas,
    Offset tip,
    double length,
    double width,
  ) {
    final direction = _unitVector(
      this.direction,
    );

    final perpendicular = Offset(
      -direction.dy,
      direction.dx,
    );

    final base = tip -
        direction * length;

    final left = base +
        perpendicular * width;

    final right = base -
        perpendicular * width;

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

  @override
  bool shouldRepaint(
    _StraightArrowPainter oldDelegate,
  ) {
    return oldDelegate.direction != direction ||
        oldDelegate.length != length ||
        oldDelegate.cellSize != cellSize ||
        oldDelegate.spacing != spacing ||
        oldDelegate.color != color;
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
        4.0,
        cellSize * 0.075,
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

    _drawBentArrowHead(
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

  void _drawBentArrowHead(
    Canvas canvas,
    Offset tip,
    ArrowDirection direction,
  ) {
    final headLength = math.min(
      cellSize * 0.28,
      14.0,
    );

    final headWidth = math.min(
      cellSize * 0.18,
      9.0,
    );

    final vector = _directionVector(
      direction,
    );

    final perpendicular = Offset(
      -vector.dy,
      vector.dx,
    );

    final base = tip -
        vector * headLength;

    final left = base +
        perpendicular * headWidth;

    final right = base -
        perpendicular * headWidth;

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

  Offset _directionVector(
    ArrowDirection direction,
  ) {
    switch (direction) {
      case ArrowDirection.up:
        return const Offset(0, -1);

      case ArrowDirection.right:
        return const Offset(1, 0);

      case ArrowDirection.down:
        return const Offset(0, 1);

      case ArrowDirection.left:
        return const Offset(-1, 0);
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