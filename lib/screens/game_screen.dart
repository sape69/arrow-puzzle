import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../game/arrow.dart';
import '../game/game_board.dart';
import '../widgets/game_hud.dart';
import '../widgets/game_over_dialog.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameBoard board = GameBoard();

  int moves = 0;
  int lives = 3;

  Arrow? exitingArrow;
  Arrow? failedArrow;
  bool isAnimating = false;

  void _tapArrow(Arrow arrow) {
    if (isAnimating || failedArrow != null) {
      return;
    }

    if (!board.canExit(arrow)) {
      _wrongArrow(arrow);
      return;
    }

    setState(() {
      exitingArrow = arrow;
      isAnimating = true;
      moves++;
    });
  }

  void _wrongArrow(Arrow arrow) {
    setState(() {
      failedArrow = arrow;
      lives--;
      isAnimating = true;
    });

    Future.delayed(const Duration(milliseconds: 650), () {
      if (!mounted) {
        return;
      }

      if (lives <= 0) {
        setState(() {
          isAnimating = false;
        });

        _showGameOverDialog();
        return;
      }

      setState(() {
        failedArrow = null;
        isAnimating = false;
      });
    });
  }

  void _finishExit(Arrow arrow) {
    if (!mounted || exitingArrow != arrow) {
      return;
    }

    setState(() {
      board.removeArrow(arrow);
      exitingArrow = null;
      isAnimating = false;
    });

    if (board.arrows.isEmpty) {
      _completeLevel();
    }
  }

  void _completeLevel() {
    if (board.nextLevel()) {
      _showNextLevelDialog();
      return;
    }

    _showAllLevelsCompleteDialog();
  }

  void _showNextLevelDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Level ${board.currentLevel} Complete!',
          ),
          content: Text(
            'Get ready for Level ${board.currentLevel + 1}.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                setState(() {
                  moves = 0;
                  lives = 3;
                });
              },
              child: const Text('NEXT LEVEL'),
            ),
          ],
        );
      },
    );
  }

  void _showAllLevelsCompleteDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('All Levels Complete!'),
          content: const Text(
            'Congratulations!\nYou completed every level.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _restartGame();
              },
              child: const Text('PLAY AGAIN'),
            ),
          ],
        );
      },
    );
  }

  void _showGameOverDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return GameOverDialog(
          onTryAgain: _restartGame,
        );
      },
    );
  }

  void _restartGame() {
    setState(() {
      board.currentLevel = 0;
      board.reset();
      moves = 0;
      lives = 3;
      exitingArrow = null;
      failedArrow = null;
      isAnimating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ARROW PUZZLE • LEVEL ${board.currentLevel + 1}',
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          GameHud(
            moves: moves,
            lives: lives,
          ),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return _buildBoard(constraints);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoard(BoxConstraints constraints) {
    final boardWidth = constraints.maxWidth;
    final padding = 16.0;
    final spacing = 4.0;

    final availableWidth =
        boardWidth - (padding * 2) - (spacing * (board.size - 1));

    final cellSize = availableWidth / board.size;

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(padding),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: board.size,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
            ),
            itemCount: board.size * board.size,
            itemBuilder: (context, index) {
              final row = index ~/ board.size;
              final column = index % board.size;

              final arrow = board.arrowAt(row, column);

              return GestureDetector(
                onTap: arrow == null
                    ? null
                    : () => _tapArrow(arrow),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF21113B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
          ),
        ),
        ..._buildArrowWidgets(
          cellSize,
          spacing,
          padding,
        ),
      ],
    );
  }

  List<Widget> _buildArrowWidgets(
    double cellSize,
    double spacing,
    double padding,
  ) {
    final widgets = <Widget>[];

    for (final arrow in board.arrows) {
      if (exitingArrow == arrow || failedArrow == arrow) {
        widgets.add(
          _buildAnimatedArrow(
            arrow,
            cellSize,
            spacing,
            padding,
          ),
        );
        continue;
      }

      widgets.add(
        _buildPositionedArrow(
          arrow,
          cellSize,
          spacing,
          padding,
        ),
      );
    }

    return widgets;
  }

  Widget _buildPositionedArrow(
    Arrow arrow,
    double cellSize,
    double spacing,
    double padding,
  ) {
    final width = arrow.direction == ArrowDirection.left ||
            arrow.direction == ArrowDirection.right
        ? _arrowLength(arrow, cellSize, spacing)
        : cellSize;

    final height = arrow.direction == ArrowDirection.up ||
            arrow.direction == ArrowDirection.down
        ? _arrowLength(arrow, cellSize, spacing)
        : cellSize;

    return Positioned(
      left: _arrowLeft(
        arrow,
        cellSize,
        spacing,
        padding,
      ),
      top: _arrowTop(
        arrow,
        cellSize,
        spacing,
        padding,
      ),
      width: width,
      height: height,
      child: GestureDetector(
        onTap: () => _tapArrow(arrow),
        child: Center(
          child: _arrowVisual(
            arrow,
            Colors.white,
            cellSize,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedArrow(
    Arrow arrow,
    double cellSize,
    double spacing,
    double padding,
  ) {
    final isFailed = failedArrow == arrow;

    if (isFailed) {
      return Positioned(
        left: _arrowLeft(
          arrow,
          cellSize,
          spacing,
          padding,
        ),
        top: _arrowTop(
          arrow,
          cellSize,
          spacing,
          padding,
        ),
        width: _arrowWidth(arrow, cellSize, spacing),
        height: _arrowHeight(arrow, cellSize, spacing),
        child: TweenAnimationBuilder<double>(
          key: ValueKey('failed-$arrow'),
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            final offset = _collisionOffset(
              arrow,
              value,
              cellSize,
              spacing,
            );

            return Transform.translate(
              offset: offset,
              child: child,
            );
          },
          child: Center(
            child: _arrowVisual(
              arrow,
              Colors.red,
              cellSize,
            ),
          ),
        ),
      );
    }

    return Positioned(
      left: _arrowLeft(
        arrow,
        cellSize,
        spacing,
        padding,
      ),
      top: _arrowTop(
        arrow,
        cellSize,
        spacing,
        padding,
      ),
      width: _arrowWidth(arrow, cellSize, spacing),
      height: _arrowHeight(arrow, cellSize, spacing),
      child: TweenAnimationBuilder<double>(
        key: ValueKey(arrow),
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOut,
        onEnd: () => _finishExit(arrow),
        builder: (context, value, child) {
          final offset = _exitOffset(
            arrow,
            cellSize,
            spacing,
          );

          return Opacity(
            opacity: 1 - value,
            child: Transform.translate(
              offset: Offset(
                offset.dx * value,
                offset.dy * value,
              ),
              child: child,
            ),
          );
        },
        child: Center(
          child: _arrowVisual(
            arrow,
            Colors.green,
            cellSize,
          ),
        ),
      ),
    );
  }

  Widget _arrowVisual(
    Arrow arrow,
    Color color,
    double cellSize,
  ) {
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

  double _arrowLength(
    Arrow arrow,
    double cellSize,
    double spacing,
  ) {
    return (arrow.length * cellSize) +
        ((arrow.length - 1) * spacing);
  }

  double _arrowWidth(
    Arrow arrow,
    double cellSize,
    double spacing,
  ) {
    if (arrow.direction == ArrowDirection.left ||
        arrow.direction == ArrowDirection.right) {
      return _arrowLength(
        arrow,
        cellSize,
        spacing,
      );
    }

    return cellSize;
  }

  double _arrowHeight(
    Arrow arrow,
    double cellSize,
    double spacing,
  ) {
    if (arrow.direction == ArrowDirection.up ||
        arrow.direction == ArrowDirection.down) {
      return _arrowLength(
        arrow,
        cellSize,
        spacing,
      );
    }

    return cellSize;
  }

  double _arrowLeft(
    Arrow arrow,
    double cellSize,
    double spacing,
    double padding,
  ) {
    if (arrow.direction == ArrowDirection.left) {
      return padding +
          (arrow.column - arrow.length + 1) *
              (cellSize + spacing);
    }

    return padding +
        arrow.column * (cellSize + spacing);
  }

  double _arrowTop(
    Arrow arrow,
    double cellSize,
    double spacing,
    double padding,
  ) {
    if (arrow.direction == ArrowDirection.up) {
      return padding +
          (arrow.row - arrow.length + 1) *
              (cellSize + spacing);
    }

    return padding +
        arrow.row * (cellSize + spacing);
  }

  Offset _collisionOffset(
    Arrow arrow,
    double value,
    double cellSize,
    double spacing,
  ) {
    final collisionDistance =
        math.min(24.0, cellSize * 0.45);

    final movement = value <= 0.5
        ? value * 2 * collisionDistance
        : (1 - value) * 2 * collisionDistance;

    switch (arrow.direction) {
      case ArrowDirection.up:
        return Offset(0, -movement);

      case ArrowDirection.right:
        return Offset(movement, 0);

      case ArrowDirection.down:
        return Offset(0, movement);

      case ArrowDirection.left:
        return Offset(-movement, 0);
    }
  }

  Offset _exitOffset(
    Arrow arrow,
    double cellSize,
    double spacing,
  ) {
    final step = cellSize + spacing;

    switch (arrow.direction) {
      case ArrowDirection.up:
        return Offset(
          0,
          -(arrow.row + arrow.length) * step,
        );

      case ArrowDirection.right:
        return Offset(
          (board.size - arrow.column) * step,
          0,
        );

      case ArrowDirection.down:
        return Offset(
          0,
          (board.size - arrow.row) * step,
        );

      case ArrowDirection.left:
        return Offset(
          -(arrow.column + 1) * step,
          0,
        );
    }
  }
}