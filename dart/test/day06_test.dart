// Puzzle Solutions are null before they are solved and we can skip the tests
// ignore_for_file: dead_code, unnecessary_null_comparison, unnecessary_ignore

import 'package:test/test.dart';

import '../solutions/day06.dart';

// *******************************************************************
// Fill out the variables below according to the puzzle description!
// The test code should usually not need to be changed, apart from uncommenting
// the puzzle tests for regression testing.
// *******************************************************************

/// Paste in the small example that is given for the FIRST PART of the puzzle.
/// It will be evaluated against the `_exampleSolutionPart1` below.
/// Make sure to respect the multiline string format to avoid additional
/// newlines at the end.
const _exampleInput1 =
    '''123 328  51 64 \n 45 64  387 23 \n  6 98  215 314\n*   +   *   +  ''';

/// Paste in the small example that is given for the SECOND PART of the puzzle.
/// It will be evaluated against the `_exampleSolutionPart2` below.
///
/// In case the second part uses the same example, uncomment below line instead:
const String _exampleInput2 = _exampleInput1;

/// The solution for the FIRST PART's example, which is given by the puzzle.
const _exampleSolutionPart1 = 4277556;

/// The solution for the SECOND PART's example, which is given by the puzzle.
const _exampleSolutionPart2 = 3263827;

/// The actual solution for the FIRST PART of the puzzle, based on your input.
/// This can only be filled out after you have solved the puzzle and is used
/// for regression testing when refactoring.
/// As long as the variable is `null`, the tests will be skipped.
const _puzzleSolutionPart1 = 7229350537438;

/// The actual solution for the SECOND PART of the puzzle, based on your input.
/// This can only be filled out after you have solved the puzzle and is used
/// for regression testing when refactoring.
/// As long as the variable is `null`, the tests will be skipped.
const _puzzleSolutionPart2 = 11479269003550;

void main() {
  group('Day 06 - Example Input', () {
    test('Part 1', () {
      final day = Day06()..inputForTesting = _exampleInput1;
      expect(day.solvePart1(), _exampleSolutionPart1);
    });
    test('Part 2', () {
      final day = Day06()..inputForTesting = _exampleInput2;
      expect(day.solvePart2(), _exampleSolutionPart2);
    });
  });
  group('Day 06 - Puzzle Input', () {
    final day = Day06();
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
