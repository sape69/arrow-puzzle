import 'package:flutter/material.dart';

import '../game/arrow.dart';
import '../game/game_board.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameBoard board = GameBoard();

  int moves = 0;
  Arrow? exitingArrow;
  bool isAnimating = false;

  void _tapArrow(Arrow arrow) {
    if (isAnimating) {
      return;
    }

    if (!board.canExit(arrow)) {
      return;
    }

    setState(() {
      exitingArrow = arrow;
      isAnimating = true;
      moves++;
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
      _showWinDialog();
    }
  }

  void _showWinDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Level Complete!'),
          content: Text('Moves: $moves'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ARROW PUZZLE'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Text(
            'Moves: $moves',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
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
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
      onEnd: () => _finishExit(arrow),
      builder: (context, value, child) {
        final offset = _exitOffset(arrow.direction);

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
          color: Color(0xFFF8F1DF),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Offset _exitOffset(ArrowDirection direction) {
    switch (direction) {
      case ArrowDirection.up:
        return const Offset(0, -90);
      case ArrowDirection.right:
        return const Offset(90, 0);
      case ArrowDirection.down:
        return const Offset(0, 90);
      case ArrowDirection.left:
        return const Offset(-90, 0);
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