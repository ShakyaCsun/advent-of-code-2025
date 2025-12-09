// Puzzle Solutions are null before they are solved and we can skip the tests
// ignore_for_file: dead_code, unnecessary_null_comparison, unnecessary_ignore

import 'package:test/test.dart';

import '../solutions/day09.dart';

// *******************************************************************
// Fill out the variables below according to the puzzle description!
// The test code should usually not need to be changed, apart from uncommenting
// the puzzle tests for regression testing.
// *******************************************************************

/// Paste in the small example that is given for the FIRST PART of the puzzle.
/// It will be evaluated against the `_exampleSolutionPart1` below.
/// Make sure to respect the multiline string format to avoid additional
/// newlines at the end.
const _exampleInput1 = '''
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3
''';

/// Paste in the small example that is given for the SECOND PART of the puzzle.
/// It will be evaluated against the `_exampleSolutionPart2` below.
///
/// In case the second part uses the same example, uncomment below line instead:
const String _exampleInput2 = _exampleInput1;

/// The solution for the FIRST PART's example, which is given by the puzzle.
const _exampleSolutionPart1 = 50;

/// The solution for the SECOND PART's example, which is given by the puzzle.
const _exampleSolutionPart2 = 24;

/// The actual solution for the FIRST PART of the puzzle, based on your input.
/// This can only be filled out after you have solved the puzzle and is used
/// for regression testing when refactoring.
/// As long as the variable is `null`, the tests will be skipped.
const _puzzleSolutionPart1 = 4744899849;

/// The actual solution for the SECOND PART of the puzzle, based on your input.
/// This can only be filled out after you have solved the puzzle and is used
/// for regression testing when refactoring.
/// As long as the variable is `null`, the tests will be skipped.
const _puzzleSolutionPart2 = 1540192500;

void main() {
  group('Day 09 - Example Input', () {
    test('Part 1', () {
      final day = Day09()..inputForTesting = _exampleInput1;
      expect(day.solvePart1(), _exampleSolutionPart1);
    });
    test('Part 2', () {
      final day = Day09()..inputForTesting = _exampleInput2;
      expect(day.solvePart2(), _exampleSolutionPart2);
    });
  });
  group('Day 09 - Puzzle Input', () {
    final day = Day09();
    test(
      'Part 1',
      skip: _puzzleSolutionPart1 == null
          ? 'Skipped because _puzzleSolutionPart1 is null'
          : false,
      () => expect(day.solvePart1(), _puzzleSolutionPart1),
    );
    test(
      'Part 2',
      skip: _puzzleSolutionPart2 == null
          ? 'Skipped because _puzzleSolutionPart2 is null'
          : false,
      () => expect(day.solvePart2(), _puzzleSolutionPart2),
    );
  });
}
