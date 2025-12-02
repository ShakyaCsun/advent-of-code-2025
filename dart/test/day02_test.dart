// Puzzle Solutions are null before they are solved and we can skip the tests
// ignore_for_file: dead_code, unnecessary_ignore

import 'package:test/test.dart';

import '../solutions/day02.dart';

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
11-22,95-115,998-1012,1188511880-1188511890,222220-222224,
1698522-1698528,446443-446449,38593856-38593862,565653-565659,
824824821-824824827,2121212118-2121212124
''';

/// Paste in the small example that is given for the SECOND PART of the puzzle.
/// It will be evaluated against the `_exampleSolutionPart2` below.
///
/// In case the second part uses the same example, uncomment below line instead:
const String _exampleInput2 = _exampleInput1;

/// The solution for the FIRST PART's example, which is given by the puzzle.
const _exampleSolutionPart1 = 1227775554;

/// The solution for the SECOND PART's example, which is given by the puzzle.
const _exampleSolutionPart2 = 4174379265;

/// The actual solution for the FIRST PART of the puzzle, based on your input.
/// This can only be filled out after you have solved the puzzle and is used
/// for regression testing when refactoring.
/// As long as the variable is `null`, the tests will be skipped.
const _puzzleSolutionPart1 = 32976912643;

/// The actual solution for the SECOND PART of the puzzle, based on your input.
/// This can only be filled out after you have solved the puzzle and is used
/// for regression testing when refactoring.
/// As long as the variable is `null`, the tests will be skipped.
const _puzzleSolutionPart2 = 54446379122;

void main() {
  group('Day 02 - Example Input', () {
    test('Part 1', () {
      final day = Day02()..inputForTesting = _exampleInput1;
      expect(day.solvePart1(), _exampleSolutionPart1);
    });
    test('Part 2', () {
      final day = Day02()..inputForTesting = _exampleInput2;
      expect(day.solvePart2(), _exampleSolutionPart2);
    });
  });
  group('Day 02 - Puzzle Input', () {
    final day = Day02();
    test(
      'Part 1',
      skip: false,
      () => expect(day.solvePart1(), _puzzleSolutionPart1),
    );
    test(
      'Part 2',
      skip: false,
      () => expect(day.solvePart2(), _puzzleSolutionPart2),
    );
  });
}
