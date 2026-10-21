import 'package:flutter/material.dart';

import '../game/arrow.dart';
import '../game/game_board.dart';
import '../widgets/game_board_widget.dart';
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
              child: GameBoardWidget(
                board: board,
                onArrowTap: _tapArrow,
                exitingArrow: exitingArrow,
                failedArrow: failedArrow,
                onExitFinished: _finishExit,
              ),
            ),
          ),
        ],
      ),
    );
  }
}