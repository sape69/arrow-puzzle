import 'package:flutter/material.dart';

class GameHud extends StatelessWidget {
  const GameHud({
    super.key,
    required this.moves,
    required this.lives,
  });

  final int moves;
  final int lives;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Moves: $moves',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 24),
        Text(
          '❤️ $lives',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}