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

  void _tapArrow(Arrow arrow) {
    if (!board.canExit(arrow)) {
      return;
    }

    setState(() {
      board.removeArrow(arrow);
      moves++;
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
                              : Text(
                                  _arrowSymbol(arrow.direction),
                                  style: const TextStyle(
                                    fontSize: 30,
                                    color: Color(0xFFF8F1DF),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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