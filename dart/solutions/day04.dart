import '../utils/index.dart';

class Day04 extends GenericDay {
  Day04() : super(4);

  @override
  Field<String> parseInput() {
    return StringField.fromInput(input);
  }

  @override
  int solvePart1() {
    final grid = parseInput();
    return grid.allPositions.fold(0, (accessibleRolls, position) {
      final (x, y) = position;
      final value = grid.getValueAtPosition(position);
      if (value == '@') {
        final neighbours = grid.neighbours(x, y).where((neighbourPosition) {
          return grid.getValueAtPosition(neighbourPosition) == '@';
        });
        if (neighbours.length < 4) {
          return accessibleRolls + 1;
        }
      }
      return accessibleRolls;
    });
  }

  @override
  int solvePart2() {
    final grid = parseInput();
    final knownRollPositions = grid.allPositions
        .where((element) => grid.getValueAtPosition(element) == '@')
        .toSet();
    var removedRolls = 0;

    while (true) {
      var didRemoveRolls = false;
      final currentRollPositions = {...knownRollPositions};
      for (final position in currentRollPositions) {
        final (x, y) = position;
        if (grid
                .neighbours(x, y)
                .toSet()
                .intersection(currentRollPositions)
                .length <
            4) {
          didRemoveRolls = true;
          knownRollPositions.remove(position);
          removedRolls++;
        }
      }
      if (!didRemoveRolls) {
        return removedRolls;
      }
    }
  }
}
