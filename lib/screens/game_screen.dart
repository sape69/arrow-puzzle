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
          title: Text('Level ${board.currentLevel} Complete!'),
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
        title: Text('ARROW PUZZLE • LEVEL ${board.currentLevel + 1}'),
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
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: board.size,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
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
                        child: Center(
                          child: arrow == null
                              ? null
                              : _buildArrow(arrow),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrow(Arrow arrow) {
    final isExiting = exitingArrow == arrow;
    final isFailed = failedArrow == arrow;

    if (isFailed) {
      return TweenAnimationBuilder<double>(
        key: ValueKey('failed-$arrow'),
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOut,
        builder: (context, value, child) {
          final offset = _collisionOffset(arrow, value);

          return Transform.translate(
            offset: offset,
            child: child,
          );
        },
        child: Text(
          _arrowSymbol(arrow.direction),
          style: const TextStyle(
            fontSize: 30,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    if (!isExiting) {
      return Text(
        _arrowSymbol(arrow.direction),
        style: const TextStyle(
          fontSize: 30,
          color: Color(0xFFF8F1DF),
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return TweenAnimationBuilder<double>(
      key: ValueKey(arrow),
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOut,
      onEnd: () => _finishExit(arrow),
      builder: (context, value, child) {
        final offset = _exitOffset(arrow);

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
      child: Text(
        _arrowSymbol(arrow.direction),
        style: const TextStyle(
          fontSize: 30,
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Offset _collisionOffset(Arrow arrow, double value) {
    const collisionDistance = 24.0;

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

  Offset _exitOffset(Arrow arrow) {
    const cellSize = 56.0;

    switch (arrow.direction) {
      case ArrowDirection.up:
        return Offset(0, -(arrow.row + 1) * cellSize);
      case ArrowDirection.right:
        return Offset(
          (board.size - arrow.column) * cellSize,
          0,
        );
      case ArrowDirection.down:
        return Offset(
          0,
          (board.size - arrow.row) * cellSize,
        );
      case ArrowDirection.left:
        return Offset(-(arrow.column + 1) * cellSize, 0);
    }
  }

  String _arrowSymbol(ArrowDirection direction) {
    switch (direction) {
      case ArrowDirection.up:
        return '↑';
      case ArrowDirection.right:
        return '→';
      case ArrowDirection.down:
        return '↓';
      case ArrowDirection.left:
        return '←';
    }
  }
}