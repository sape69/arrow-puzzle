import 'arrow.dart';
import 'game_board.dart';

class LevelSolver {
  const LevelSolver();

  bool isSolvable(GameBoard board) {
    return findSolution(board) != null;
  }

  List<Arrow>? findSolution(GameBoard board) {
    final originalArrows = List<Arrow>.from(board.arrows);
    final indexByArrow = <Arrow, int>{
      for (var i = 0; i < originalArrows.length; i++)
        originalArrows[i]: i,
    };

    final failedStates = <String>{};
    final solution = <Arrow>[];

    final solved = _search(
      board,
      originalArrows,
      indexByArrow,
      failedStates,
      solution,
    );

    if (!solved) {
      return null;
    }

    return List<Arrow>.from(solution);
  }

  bool _search(
    GameBoard board,
    List<Arrow> originalArrows,
    Map<Arrow, int> indexByArrow,
    Set<String> failedStates,
    List<Arrow> solution,
  ) {
    if (board.arrows.isEmpty) {
      return true;
    }

    final state = _stateKey(
      board,
      originalArrows,
      indexByArrow,
    );

    if (failedStates.contains(state)) {
      return false;
    }

    final movable = <Arrow>[];

    for (final arrow in List<Arrow>.from(board.arrows)) {
      if (board.canExit(arrow)) {
        movable.add(arrow);
      }
    }

    if (movable.isEmpty) {
      failedStates.add(state);
      return false;
    }

    for (final arrow in movable) {
      board.removeArrow(arrow);
      solution.add(arrow);

      if (_search(
        board,
        originalArrows,
        indexByArrow,
        failedStates,
        solution,
      )) {
        return true;
      }

      solution.removeLast();
      board.arrows.add(arrow);
    }

    failedStates.add(state);
    return false;
  }

  String _stateKey(
    GameBoard board,
    List<Arrow> originalArrows,
    Map<Arrow, int> indexByArrow,
  ) {
    final remaining = <int>[];

    for (final arrow in board.arrows) {
      final index = indexByArrow[arrow];

      if (index != null) {
        remaining.add(index);
      }
    }

    remaining.sort();

    return remaining.join(',');
  }
}