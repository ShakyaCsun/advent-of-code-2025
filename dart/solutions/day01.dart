import '../utils/index.dart';

class Day01 extends GenericDay {
  Day01() : super(1);

  @override
  List<(bool, int)> parseInput() {
    final rotations = input.getPerLine();
    return rotations.map((e) {
      final isLeft = e.startsWith('L');
      final number = int.parse(e.substring(1));
      return (isLeft, number);
    }).toList();
  }

  @override
  int solvePart1() {
    var dial = 50;
    var zeroes = 0;
    for (final (isLeft, turns) in parseInput()) {
      if (isLeft) {
        dial -= turns;
      } else {
        dial += turns;
      }
      while (dial > 99) {
        dial -= 100;
      }
      while (dial < 0) {
        dial += 100;
      }
      if (dial == 0) {
        zeroes++;
      }
    }
    return zeroes;
  }

  @override
  int solvePart2() {
    var dial = 50;
    var zeroes = 0;
    for (final (isLeft, turns) in parseInput()) {
      final initialValue = dial;
      if (isLeft) {
        dial -= turns;
      } else {
        dial += turns;
      }
      if (dial == 0) {
        zeroes++;
      }
      while (dial > 99) {
        dial -= 100;
        zeroes++;
      }
      while (dial < 0) {
        dial += 100;
        zeroes++;
        if (dial == 0) {
          zeroes++;
        }
      }
      if (isLeft && initialValue == 0) {
        zeroes--;
      }
    }
    return zeroes;
  }
}
