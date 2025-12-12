import 'package:equatable/equatable.dart';

import '../utils/index.dart';

class Day12 extends GenericDay {
  Day12() : super(12);

  @override
  FinalGift parseInput() {
    return FinalGift.fromInput(input);
  }

  @override
  int solvePart1() {
    final FinalGift(:shapes, :allShapes, :regionRequirements) = parseInput();
    final clearlyPossible = <List<int>>[];
    final clearlyImpossible = <List<int>>[];
    final moreWorkRequired = <List<int>>[];
    for (final MapEntry(key: (length, breadth), value: amounts)
        in regionRequirements.entries) {
      final regionArea = length * breadth;
      for (final presentsAmount in amounts) {
        /// Assuming all shapes are fully filled 3x3 blocks, the required
        /// presents would take an area of maxArea
        final maxArea = presentsAmount.fold(
          0,
          (previousValue, element) => previousValue + element * 9,
        );

        /// if the shapes were able to be packed such that no empty spaces were
        /// to remain, we would need at least this much area.
        final minArea = presentsAmount.foldIndexed(0, (
          index,
          previous,
          element,
        ) {
          return previous + element * (9 - shapes[index].count('.'));
        });
        if (regionArea >= maxArea) {
          /// if the shapes were actually 3x3 solid blocks, this check is not
          /// actually sufficient
          clearlyPossible.add(presentsAmount);
        } else if (regionArea < minArea) {
          clearlyImpossible.add(presentsAmount);
        } else {
          /// should not reach this point in actual input
          print(presentsAmount);
          moreWorkRequired.add(presentsAmount);
        }
      }
    }
    assert(
      moreWorkRequired.isEmpty,
      "Don't be trolling me if you are not the example input",
    );

    /// When you have eliminated the impossible, whatever remains, however
    /// improbable, must be the truth. -Sherlock Elves of r/AdventOfCode
    return clearlyPossible.length;
  }

  @override
  int solvePart2() {
    return 0;
  }
}

class FinalGift extends Equatable {
  FinalGift({required this.shapes, required this.regionRequirements})
    : allShapes = {...shapes.expand((e) => e.allRotationsAndFlips())};

  factory FinalGift.fromInput(InputUtil input) {
    final [...shapeData, regionData] = input.asString.trim().split('\n\n');
    final regionRequirements = <(int, int), List<List<int>>>{};

    for (final line in regionData.split('\n')) {
      final [shape, presents] = line.split(': ');
      final [x, y] = shape.split('x').map(int.parse).toList();
      final requiredAmounts = presents.split(' ').map(int.parse).toList();
      final key = (x, y);
      final alternateKey = (y, x);
      if (regionRequirements.containsKey(alternateKey)) {
        regionRequirements.update(
          alternateKey,
          (value) => [...value, requiredAmounts],
        );
      } else {
        regionRequirements.update(
          key,
          (value) => [...value, requiredAmounts],
          ifAbsent: () => [requiredAmounts],
        );
      }
    }
    final shapes = shapeData.mapIndexed<Field<String>>((index, shape) {
      final [_, ...shapeField] = shape.replaceAll('#', '$index').split('\n');
      return Field(shapeField.map((line) => line.split('')).toList());
    }).toList();
    return FinalGift(shapes: shapes, regionRequirements: regionRequirements);
  }

  final List<Field<String>> shapes;
  final Map<(int, int), List<List<int>>> regionRequirements;

  final Set<Field<String>> allShapes;

  @override
  List<Object> get props => [shapes, regionRequirements];
}
