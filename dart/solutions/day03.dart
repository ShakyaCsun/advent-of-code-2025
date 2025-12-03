import '../utils/index.dart';

class Day03 extends GenericDay {
  Day03() : super(3);

  @override
  Field<int> parseInput() {
    return IntegerField.fromString(input.asString.trim());
  }

  @override
  int solvePart1() {
    return parseInput().field.fold(0, (previousValue, element) {
      return previousValue + element.largestJoltagePartOne;
    });
  }

  @override
  int solvePart2() {
    return parseInput().field.fold(0, (previousValue, element) {
      return previousValue + element.largestJoltage();
    });
  }
}

extension on List<int> {
  int get largestJoltagePartOne {
    final maxDigit = this.max;
    final countOfMax = where((element) => element == maxDigit).length;
    if (countOfMax >= 2) {
      return maxDigit * 10 + maxDigit;
    }
    final indexOfMax = indexWhere((element) => element == maxDigit);
    if (indexOfMax == length - 1) {
      return (take(length - 1).max) * 10 + maxDigit;
    }
    return maxDigit * 10 + skip(indexOfMax + 1).max;
  }

  int largestJoltage({int digits = 12}) {
    if (length == digits) {
      return int.parse(join());
    }
    if (digits == 2) {
      return largestJoltagePartOne;
    }
    final canditatesForFirstDigit = take(length - digits + 1);
    final firstDigit = canditatesForFirstDigit.max;
    final possibleAnswers = <int>[];
    for (final (index, digit) in canditatesForFirstDigit.indexed) {
      if (digit == firstDigit) {
        possibleAnswers.add(
          skip(index + 1).toList().largestJoltage(digits: digits - 1),
        );
      }
    }
    return int.parse('$firstDigit${possibleAnswers.max}');
  }
}
