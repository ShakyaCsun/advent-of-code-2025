import '../utils/index.dart';

class Day05 extends GenericDay {
  Day05() : super(5);

  @override
  IngredientsDb parseInput() {
    return IngredientsDb.from(input);
  }

  @override
  int solvePart1() {
    return parseInput().freshIds.length;
  }

  @override
  int solvePart2() {
    return parseInput().normalizedRanges.fold(0, (previousValue, element) {
      return previousValue + element.upper - element.lower + 1;
    });
  }
}

class IngredientsDb {
  IngredientsDb({required this.freshRange, required this.ingredients});

  factory IngredientsDb.from(InputUtil input) {
    final [ranges, ids] = input.asString.trim().split('\n\n');
    return IngredientsDb(
      freshRange: ranges.split('\n').map((e) {
        final [a, b] = e.split('-').map(int.parse).toList();
        return (a, b);
      }).toList(),
      ingredients: ids.split('\n').map(int.parse).toList(),
    );
  }

  final List<Range> freshRange;
  final List<int> ingredients;

  List<int> get freshIds {
    return ingredients.where((id) {
      return freshRange.any((range) {
        return range.isInRange(id);
      });
    }).toList();
  }

  List<Range> get normalizedRanges {
    var overlappingRanges = true;
    var knownRanges = [...freshRange];
    while (overlappingRanges) {
      overlappingRanges = false;
      final fixedRanges = <Range>{};
      final mergedIndices = <int>{};
      for (final (index, range) in knownRanges.indexed) {
        if (mergedIndices.contains(index)) {
          continue;
        }
        final canMergeWith = <int>[];
        for (final (skippedIndex, otherRange)
            in knownRanges.skip(index + 1).indexed) {
          if (range.canMerge(otherRange)) {
            final actualIndex = skippedIndex + index + 1;
            canMergeWith.add(actualIndex);
            overlappingRanges = true;
          }
        }
        mergedIndices.addAll([index, ...canMergeWith]);
        final fixedRange = canMergeWith.fold(
          range,
          (previousValue, element) => previousValue.merge(knownRanges[element]),
        );
        fixedRanges.add(fixedRange);
      }

      knownRanges = [...fixedRanges];
    }
    return knownRanges;
  }
}

extension on Range {
  bool canMerge(Range other) {
    return isInRange(other.lower) ||
        isInRange(other.upper) ||
        other.isInRange(lower) ||
        other.isInRange(upper);
  }

  Range merge(Range other) {
    final limits = <int>{lower, upper, other.lower, other.upper};
    return (limits.min, limits.max);
  }
}
