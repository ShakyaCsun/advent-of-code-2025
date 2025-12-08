import 'dart:collection';

import '../utils/index.dart';

class Day08 extends GenericDay {
  Day08() : super(8);

  @override
  List<Position3d> parseInput() {
    return input.getPerLine().map((e) {
      final [x, y, z] = e.split(',').map(int.parse).toList();
      return (x, y, z);
    }).toList();
  }

  @override
  int solvePart1() {
    final positions = parseInput();
    return connectBoxes(positions);
  }

  @override
  int solvePart2() {
    final positions = parseInput();
    return connectBoxes(positions, partTwo: true);
  }

  int connectBoxes(
    List<Position3d> positions, {
    int maxConnections = 1000,
    bool partTwo = false,
  }) {
    final boxesCount = positions.length;
    final distances = <int, List<(Position3d, Position3d)>>{};
    for (final (index, position) in positions.indexed) {
      for (final otherPosition in positions.skip(index + 1)) {
        final distance = position.distanceSquare(otherPosition);
        distances.update(distance, (value) {
          return [...value, (position, otherPosition)];
        }, ifAbsent: () => [(position, otherPosition)]);
      }
    }
    final circuits = <Set<Position3d>>[];
    var connections = 0;
    for (final MapEntry(key: _, value: pairsList) in distances.entries.sortedBy(
      (element) => element.key,
    )) {
      for (final (p0, p1) in pairsList) {
        connections++;
        bool isConnected(Set<Position3d> circuit) {
          return circuit.contains(p0) || circuit.contains(p1);
        }

        final connectedCircuits = circuits.where(isConnected).toList();
        if (connectedCircuits.isEmpty) {
          circuits.add({p0, p1});
        } else {
          circuits
            ..removeWhere(isConnected)
            ..add(
              connectedCircuits.fold({p0, p1}, (previousValue, element) {
                return previousValue.union(element);
              }),
            );
        }
        if (partTwo &&
            circuits.length == 1 &&
            circuits.first.length == boxesCount) {
          return p0.x * p1.x;
        }
      }
      if (!partTwo && connections == maxConnections) {
        return circuits
            .map<int>((e) => e.length)
            .sorted((a, b) => b.compareTo(a))
            .take(3)
            .fold(1, (previousValue, element) {
              return previousValue * element;
            });
      }
    }
    return -1;
  }
}

typedef Position3d = (int x, int y, int z);

extension on Position3d {
  int get x => $1;
  int get y => $2;
  int get z => $3;

  int distanceSquare(Position3d other) {
    final dx = x - other.x;
    final dy = y - other.y;
    final dz = z - other.z;
    return dx * dx + dy * dy + dz * dz;
  }
}
