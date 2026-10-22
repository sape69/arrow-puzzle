import 'arrow.dart';
import 'game_board.dart';

class LevelSolver {
  const LevelSolver();

  bool isSolvable(GameBoard board) {
    return findSolution(board) != null;
  }

  List<Arrow>? findSolution(GameBoard board) {
    final solution = <Arrow>[];
    final failedStates = <String>{};

    final solved = _search(
      board,
      solution,
      failedStates,
    );

    if (!solved) {
      return null;
    }

    return List<Arrow>.from(solution);
  }

  bool _search(
    GameBoard board,
    List<Arrow> solution,
    Set<String> failedStates,
  ) {
    if (board.arrows.isEmpty) {
      return true;
    }

    final state = _stateKey(board);

    if (failedStates.contains(state)) {
      return false;
    }

    final movable = <Arrow>[];

    for (final arrow in board.arrows) {
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
        solution,
        failedStates,
      )) {
        return true;
      }

      solution.removeLast();
      board.arrows.add(arrow);
    }

    failedStates.add(state);
    return false;
  }

  String _stateKey(GameBoard board) {
    final remaining = <String>[];

    for (final arrow in board.arrows) {
      remaining.add(_arrowKey(arrow));
    }

    remaining.sort();

    return remaining.join('|');
  }

  String _arrowKey(Arrow arrow) {
    final path = arrow.path
        .map(
          (direction) => direction.name,
        )
        .join(',');

    return [
      arrow.row,
      arrow.column,
      arrow.direction.name,
      arrow.length,
      path,
    ].join(':');
  }
}