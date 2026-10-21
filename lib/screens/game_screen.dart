import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../game/arrow.dart';
import '../game/game_board.dart';
import '../widgets/arrow_exit_animation.dart';
import '../widgets/arrow_widget.dart';
import '../widgets/game_hud.dart';
import '../widgets/game_over_dialog.dart';
import 'level_select_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    this.startLevel = 0,
  });

  final int startLevel;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameBoard board;

  int moves = 0;
  int lives = 3;

  Arrow? exitingArrow;
  Arrow? failedArrow;
  bool isAnimating = false;

  @override
  void initState() {
    super.initState();

    board = GameBoard();
    board.currentLevel = widget.startLevel;
    board.reset();
  }

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

    Future.delayed(
      const Duration(milliseconds: 650),
      () {
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
      },
    );
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
          title: const Text(
            'All Levels Complete!',
          ),
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
          onTryAgain: _restartCurrentLevel,
        );
      },
    );
  }

  void _restartCurrentLevel() {
    setState(() {
      board.reset();
      moves = 0;
      lives = 3;
      exitingArrow = null;
      failedArrow = null;
      isAnimating = false;
    });
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

  Future<void> _selectLevel() async {
    if (isAnimating) {
      return;
    }

    final selectedLevel = await Navigator.of(context).push<int>(
      MaterialPageRoute(
        builder: (_) => const LevelSelectScreen(),
      ),
    );

    if (!mounted || selectedLevel == null) {
      return;
    }

    setState(() {
      board.currentLevel = selectedLevel;
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
        actions: [
          IconButton(
            onPressed: _selectLevel,
            tooltip: 'Select level',
            icon: const Icon(
              Icons.grid_view_rounded,
            ),
          ),
        ],
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

  Widget _buildBoard(
    BoxConstraints constraints,
  ) {
    final boardWidth = constraints.maxWidth;

    const padding = 16.0;
    const spacing = 4.0;

    final availableWidth =
        boardWidth -
        (padding * 2) -
        (spacing * (board.size - 1));

    final cellSize = availableWidth / board.size;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.all(padding),
          child: GridView.builder(
            physics:
                const NeverScrollableScrollPhysics(),
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

              final arrow = board.arrowAt(
                row,
                column,
              );

              return GestureDetector(
                onTap: arrow == null
                    ? null
                    : () => _tapArrow(arrow),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF21113B),
                    borderRadius:
                        BorderRadius.circular(8),
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
        if (exitingArrow != null)
          _buildExitAnimation(
            exitingArrow!,
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
      if (arrow == exitingArrow) {
        continue;
      }

      widgets.add(
        _buildArrow(
          arrow,
          cellSize,
          spacing,
          padding,
        ),
      );
    }

    return widgets;
  }

  Widget _buildArrow(
    Arrow arrow,
    double cellSize,
    double spacing,
    double padding,
  ) {
    final isFailed = failedArrow == arrow;

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
      width: _arrowWidth(
        arrow,
        cellSize,
        spacing,
      ),
      height: _arrowHeight(
        arrow,
        cellSize,
        spacing,
      ),
      child: IgnorePointer(
        child: isFailed
            ? _buildFailedArrow(
                arrow,
                cellSize,
              )
            : _buildNormalArrow(
                arrow,
                cellSize,
              ),
      ),
    );
  }

  Widget _buildExitAnimation(
    Arrow arrow,
    double cellSize,
    double spacing,
    double padding,
  ) {
    final startX =
        padding +
        arrow.column *
            (cellSize + spacing);

    final startY =
        padding +
        arrow.row *
            (cellSize + spacing);

    return Positioned.fill(
      child: IgnorePointer(
        child: Transform.translate(
          offset: Offset(
            startX,
            startY,
          ),
          child: TweenAnimationBuilder<double>(
            key: ValueKey(
              'exit-${arrow.hashCode}',
            ),
            tween: Tween(
              begin: 0,
              end: 1,
            ),
            duration: const Duration(
              milliseconds: 700,
            ),
            curve: Curves.easeInOut,
            onEnd: () => _finishExit(arrow),
            builder: (
              context,
              value,
              child,
            ) {
              return ArrowExitAnimation(
                arrow: arrow,
                progress: value,
                cellSize: cellSize,
                spacing: spacing,
                boardSize: board.size,
                color: Colors.green,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNormalArrow(
    Arrow arrow,
    double cellSize,
  ) {
    return Center(
      child: ArrowWidget(
        arrow: arrow,
        cellSize: cellSize,
      ),
    );
  }

  Widget _buildFailedArrow(
    Arrow arrow,
    double cellSize,
  ) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(
        'failed-$arrow',
      ),
      tween: Tween(
        begin: 0,
        end: 1,
      ),
      duration: const Duration(
        milliseconds: 650,
      ),
      curve: Curves.easeInOut,
      builder: (
        context,
        value,
        child,
      ) {
        final offset = _collisionOffset(
          arrow,
          value,
          cellSize,
        );

        return Transform.translate(
          offset: offset,
          child: child,
        );
      },
      child: Center(
        child: ArrowWidget(
          arrow: arrow,
          cellSize: cellSize,
          color: Colors.red,
        ),
      ),
    );
  }

  double _arrowWidth(
    Arrow arrow,
    double cellSize,
    double spacing,
  ) {
    if (arrow.isBent) {
      return _bentWidth(
        arrow,
        cellSize,
        spacing,
      );
    }

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
    if (arrow.isBent) {
      return _bentHeight(
        arrow,
        cellSize,
        spacing,
      );
    }

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

  double _arrowLength(
    Arrow arrow,
    double cellSize,
    double spacing,
  ) {
    return (arrow.length * cellSize) +
        ((arrow.length - 1) * spacing);
  }

  double _bentWidth(
    Arrow arrow,
    double cellSize,
    double spacing,
  ) {
    var column = 0;
    var minColumn = 0;
    var maxColumn = 0;

    for (final direction in arrow.path) {
      switch (direction) {
        case ArrowDirection.left:
          column--;
          break;
        case ArrowDirection.right:
          column++;
          break;
        case ArrowDirection.up:
        case ArrowDirection.down:
          break;
      }

      minColumn = math.min(
        minColumn,
        column,
      );

      maxColumn = math.max(
        maxColumn,
        column,
      );
    }

    return ((maxColumn - minColumn + 1) *
            cellSize) +
        ((maxColumn - minColumn) * spacing);
  }

  double _bentHeight(
    Arrow arrow,
    double cellSize,
    double spacing,
  ) {
    var row = 0;
    var minRow = 0;
    var maxRow = 0;

    for (final direction in arrow.path) {
      switch (direction) {
        case ArrowDirection.up:
          row--;
          break;
        case ArrowDirection.down:
          row++;
          break;
        case ArrowDirection.left:
        case ArrowDirection.right:
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
    }

    return ((maxRow - minRow + 1) *
            cellSize) +
        ((maxRow - minRow) * spacing);
  }

  double _arrowLeft(
    Arrow arrow,
    double cellSize,
    double spacing,
    double padding,
  ) {
    if (arrow.isBent) {
      return _bentLeft(
        arrow,
        cellSize,
        spacing,
        padding,
      );
    }

    if (arrow.direction == ArrowDirection.left) {
      return padding +
          (arrow.column - arrow.length + 1) *
              (cellSize + spacing);
    }

    return padding +
        arrow.column *
            (cellSize + spacing);
  }

  double _arrowTop(
    Arrow arrow,
    double cellSize,
    double spacing,
    double padding,
  ) {
    if (arrow.isBent) {
      return _bentTop(
        arrow,
        cellSize,
        spacing,
        padding,
      );
    }

    if (arrow.direction == ArrowDirection.up) {
      return padding +
          (arrow.row - arrow.length + 1) *
              (cellSize + spacing);
    }

    return padding +
        arrow.row *
            (cellSize + spacing);
  }

  double _bentLeft(
    Arrow arrow,
    double cellSize,
    double spacing,
    double padding,
  ) {
    var column = 0;
    var minColumn = 0;

    for (final direction in arrow.path) {
      if (direction == ArrowDirection.left) {
        column--;
      } else if (direction == ArrowDirection.right) {
        column++;
      }

      minColumn = math.min(
        minColumn,
        column,
      );
    }

    return padding +
        (arrow.column + minColumn) *
            (cellSize + spacing);
  }

  double _bentTop(
    Arrow arrow,
    double cellSize,
    double spacing,
    double padding,
  ) {
    var row = 0;
    var minRow = 0;

    for (final direction in arrow.path) {
      if (direction == ArrowDirection.up) {
        row--;
      } else if (direction == ArrowDirection.down) {
        row++;
      }

      minRow = math.min(
        minRow,
        row,
      );
    }

    return padding +
        (arrow.row + minRow) *
            (cellSize + spacing);
  }

  Offset _collisionOffset(
    Arrow arrow,
    double value,
    double cellSize,
  ) {
    final collisionDistance = math.min(
      24.0,
      cellSize * 0.45,
    );

    final movement = value <= 0.5
        ? value * 2 * collisionDistance
        : (1 - value) *
            2 *
            collisionDistance;

    switch (arrow.direction) {
      case ArrowDirection.up:
        return Offset(
          0,
          -movement,
        );

      case ArrowDirection.right:
        return Offset(
          movement,
          0,
        );

      case ArrowDirection.down:
        return Offset(
          0,
          movement,
        );

      case ArrowDirection.left:
        return Offset(
          -movement,
          0,
        );
    }
  }
}