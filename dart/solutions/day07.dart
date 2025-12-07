import '../utils/index.dart';

class Day07 extends GenericDay {
  Day07() : super(7);

  @override
  Field<String> parseInput() {
    return StringField.fromInput(input);
  }

  @override
  int solvePart1() {
    final field = parseInput();
    final startIndex = field
        .getRow(0)
        .toList()
        .indexWhere((element) => element == 'S');
    return field.sendBeamOne(startIndex);
  }

  @override
  int solvePart2() {
    final field = parseInput();
    final startIndex = field
        .getRow(0)
        .toList()
        .indexWhere((element) => element == 'S');
    return field.sendBeamTwo(startIndex);
  }
}

extension on Field<String> {
  int sendBeamOne(int startIndex) {
    var numberOfSplits = 0;
    var beams = [startIndex];
    for (final row in rows) {
      final nextBeams = <int>{};
      for (final beamIndex in beams) {
        if (row[beamIndex] == '^') {
          // // Always valid
          // final validSplit = <int>[
          //   if (beamIndex - 1 >= 0) beamIndex - 1,
          //   if (beamIndex + 1 < row.length) beamIndex + 1,
          // ];
          numberOfSplits++;
          nextBeams.addAll([beamIndex - 1, beamIndex + 1]);
        } else {
          nextBeams.add(beamIndex);
        }
      }
      beams = [...nextBeams];
    }
    return numberOfSplits;
  }

  int sendBeamTwo(int startIndex) {
    var beamTimelines = <int, int>{startIndex: 1};
    for (final row in rows) {
      final nextBeams = <int, int>{};
      for (final MapEntry(key: beamIndex, value: timelines)
          in beamTimelines.entries) {
        if (row[beamIndex] == '^') {
          nextBeams
            ..update(
              beamIndex - 1,
              (value) => value + timelines,
              ifAbsent: () => timelines,
            )
            ..update(
              beamIndex + 1,
              (value) => value + timelines,
              ifAbsent: () => timelines,
            );
        } else {
          nextBeams.update(
            beamIndex,
            (value) => value + timelines,
            ifAbsent: () => timelines,
          );
        }
      }
      beamTimelines = {...nextBeams};
    }
    return beamTimelines.values.fold(0, (previousValue, element) {
      return previousValue + element;
    });
  }
}
