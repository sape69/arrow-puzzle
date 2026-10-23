import '../game_board.dart';
import '../level_data.dart';
import '../level_solver.dart';

class LevelValidator {
  const LevelValidator();

  List<dynamic>? findSolution(LevelData level) {
    final board = GameBoard(
      level: level,
    );

    const solver = LevelSolver();

    return solver.findSolution(board);
  }

  bool isSolvable(LevelData level) {
    return findSolution(level) != null;
  }
}