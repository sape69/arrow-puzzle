import '../../arrow.dart';
import 'reverse_solution_path.dart';

class ReverseSolutionPlacementValidator {
const ReverseSolutionPlacementValidator({
ReverseSolutionPath solutionPath =
const ReverseSolutionPath(),
}) : _solutionPath = solutionPath;

final ReverseSolutionPath _solutionPath;

bool canPlace({
required Arrow candidate,
required List<Arrow> existing,
required int boardSize,
}) {
if (boardSize < 1) {
return false;
}

if (!_canPlaceWithoutBlockingExisting(
  candidate: candidate,
  existing: existing,
  boardSize: boardSize,
)) {
  return false;
}

return _candidateCanExit(
  candidate: candidate,
  existing: existing,
  boardSize: boardSize,
);

}

bool _canPlaceWithoutBlockingExisting({
required Arrow candidate,
required List<Arrow> existing,
required int boardSize,
}) {
final simulated = <Arrow>[
...existing,
candidate,
];

for (final arrow in existing) {
  if (!_solutionPath.canExit(
    arrow: arrow,
    arrows: simulated,
    boardSize: boardSize,
  )) {
    return false;
  }
}

return true;

}

bool _candidateCanExit({
required Arrow candidate,
required List<Arrow> existing,
required int boardSize,
}) {
return _solutionPath.canExit(
arrow: candidate,
arrows: [
...existing,
candidate,
],
boardSize: boardSize,
);
}
}