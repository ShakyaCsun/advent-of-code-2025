import '../utils/index.dart';

class Day02 extends GenericDay {
  Day02() : super(2);

  @override
  List<(int, int)> parseInput() {
    return input.asString.trim().split(',').map((range) {
      final [min, max] = range.split('-');
      return (int.parse(min), int.parse(max));
    }).toList();
  }

  @override
  int solvePart1() {
    // // 2_533_508 so around 2.5 million
    // print(
    //   parseInput().fold<int>(0, (previousValue, element) {
    //     return previousValue + element.$2 - element.$1 + 1;
    //   }),
    // );
    return parseInput().fold(0, (previousValue, element) {
      return previousValue +
          element.invalidId1.fold(0, (previousValue, ids) {
            // print(ids);
            return previousValue + ids;
          });
    });
  }

  @override
  int solvePart2() {
    return parseInput().fold(0, (previousValue, element) {
      return previousValue +
          element.invalidId2.fold(0, (previousValue, ids) {
            // print(ids);
            return previousValue + ids;
          });
    });
  }
}

extension on (int, int) {
  List<int> get invalidId1 {
    final (left, right) = this;
    final (stringLeft, stringRight) = (left.toString(), right.toString());

    final minHalf = stringLeft.firstHalf();

    final maxHalf = stringRight.firstHalf(isStart: false);
    final possibleInvalidIds = <int>{minHalf.invalidId};
    var halfId = int.tryParse(minHalf) ?? 0;
    final maxHalfId = int.tryParse(maxHalf) ?? 0;
    while (halfId <= maxHalfId) {
      halfId++;
      possibleInvalidIds.add('$halfId'.invalidId);
    }
    return possibleInvalidIds.where(isInRange).toList();
  }

  List<int> get invalidId2 {
    final (left, right) = this;
    final numbers = List.generate(right - left + 1, (index) => left + index);
    return numbers.where((element) => element.isInvalidId).toList();
  }

  bool isInRange(int id) {
    return $1 <= id && $2 >= id;
  }
}

extension on String {
  int get invalidId {
    try {
      if (this.isEmpty) {
        return 0;
      }
      return int.parse('$this$this');
    } on Exception {
      print('$this is invalid integer');
      rethrow;
    }
  }

  String firstHalf({bool isStart = true}) {
    if (isStart) {
      if (length.isOdd) {
        return substring(0, length ~/ 2);
      }
      return substring(0, length ~/ 2);
    }

    if (length.isOdd) {
      return substring(0, length ~/ 2 + 1);
    }
    return substring(0, length ~/ 2);
  }

  int getInvalidId({int times = 2}) {
    if (this.isEmpty) {
      return 0;
    }
    final idBuffer = StringBuffer();
    for (var i = 0; i < times; i++) {
      idBuffer.write(this);
    }
    return int.parse(idBuffer.toString());
  }
}

extension on int {
  bool get isInvalidId {
    final strId = toString();
    final length = strId.length;
    final factors = List.generate(
      length ~/ 2,
      (index) => index + 1,
    ).where((element) => length % element == 0).toList();
    for (final factor in factors) {
      final invalidId = strId
          .substring(0, factor)
          .getInvalidId(times: length ~/ factor);
      if (this == invalidId) {
        return true;
      }
    }
    return false;
  }
}
