import 'package:graphs/graphs.dart';

import '../utils/index.dart' hide transitiveClosure;

class Day11 extends GenericDay {
  Day11() : super(11);

  @override
  Map<String, Set<String>> parseInput() {
    return Map.fromEntries(
      input.getPerLine().map((line) {
        final [key, outputs] = line.split(': ');
        return MapEntry(key, outputs.split(' ').toSet());
      }),
    );
  }

  @override
  int solvePart1() {
    final connections = parseInput();
    var waysToOut = 0;
    final nextNodes = QueueList.from(connections['you']!);
    while (nextNodes.isNotEmpty) {
      final node = nextNodes.removeFirst();
      if (node == 'out') {
        waysToOut++;
        continue;
      }
      final next = connections[node];
      if (next case final next?) {
        nextNodes.addAll(next);
      }
    }
    return waysToOut;
  }

  @override
  int solvePart2() {
    const serverRack = 'svr';
    const dac = 'dac';
    const fft = 'fft';
    const out = 'out';
    final connections = parseInput();
    final closure = transitiveClosure([serverRack], (key) {
      return connections[key] ?? [];
    });
    // There are only two possible ways to get from 'svr' to 'out' while going
    // through both dac and fft:
    // 1. svr -> dac -> fft -> out
    // 2. svr -> fft -> dac -> out
    // Out of which only one way can be valid for an input,
    // otherwise we hit a cycle between dac and fft hence creating infinite ways
    // to get to `out` by going from dac to fft/fft to dac many number of times.
    final possiblePathsOrder = [
      [serverRack, dac, fft, out],
      [serverRack, fft, dac, out],
    ];

    // Either there will be no path from dac to fft or from fft to dac in our
    // transitive closure leaving behind a single `validPath`.
    // In my input and the example, only fft can go to dac while dac cannot go
    // to fft. I don't know if that is always true, but now the code handles
    // both cases.
    final [validPath] = possiblePathsOrder.map((e) => e.adjacentPairs).where((
      pairs,
    ) {
      // A path is valid if we can go from one point to next point i.e.
      // 1. svr can go to dac, dac can go to fft, and fft can go to out. Or,
      // 2. svr can go to fft, fft can go to dac, and dac can go to out.
      return pairs.every((pair) {
        final (from, to) = pair;
        return closure[from]!.contains(to);
      });
    }).toList();
    return validPath.fold(1, (previousValue, pair) {
      final (from, to) = pair;
      // If there are 'x' ways to go from A to B, and 'y' ways to go from
      // B to C, then there are 'x * y' ways to go from A to C through B.
      return previousValue *
          getNumberOfPaths(connections, from: from, to: to, closure: closure);
    });
  }

  int getNumberOfPaths(
    Map<String, Set<String>> connections, {
    required String from,
    required String to,
    required Map<String, Set<String>> closure,
  }) {
    final nextNodes = QueueList.from([from]);
    var validPathsCount = 0;
    while (nextNodes.isNotEmpty) {
      final node = nextNodes.removeFirst();
      if (node == to) {
        validPathsCount++;
        continue;
      }

      if (!closure[node]!.contains(to)) {
        // If this node cannot reach our destination `to`, ignore this path.
        continue;
      }
      final next = connections[node];
      if (next case final next?) {
        nextNodes.addAll(next);
      }
    }
    return validPathsCount;
  }
}
