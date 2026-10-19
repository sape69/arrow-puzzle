import 'package:flutter/material.dart';

import '../game/arrow.dart';
import '../game/game_board.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final board = GameBoard();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ARROW PUZZLE'),
        centerTitle: true,
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: board.size,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: board.size * board.size,
            itemBuilder: (context, index) {
              final row = index ~/ board.size;
              final column = index % board.size;

              final arrow = board.arrows
                  .where(
                    (item) =>
                        item.row == row && item.column == column,
                  )
                  .firstOrNull;

              return Container(
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
              );
            },
          ),
        ),
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