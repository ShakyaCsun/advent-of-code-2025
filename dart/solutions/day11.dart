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
    final closure = transitiveClosure(
      connections.keys,
      (key) => connections[key] ?? [],
    );
    final waysFromDacToOut = getPaths(
      connections,
      from: dac,
      to: out,
      closure: closure,
    );
    final waysFromFftToDac = getPaths(
      connections,
      from: fft,
      to: dac,
      closure: closure,
    );
    final waysFromSvrToFft = getPaths(
      connections,
      from: serverRack,
      to: fft,
      closure: closure,
    );
    return waysFromSvrToFft * waysFromFftToDac * waysFromDacToOut;
  }

  int getPaths(
    Map<String, Set<String>> connections, {
    required String from,
    required String to,
    required Map<String, Set<String>> closure,
    String? through,
  }) {
    final nextNodes = QueueList.from([from]);
    var validPathsCount = 0;
    final hasThrough = through != null;
    final pathsFromThrough = hasThrough
        ? getPaths(connections, from: through, to: to, closure: closure)
        : 0;
    while (nextNodes.isNotEmpty) {
      final node = nextNodes.removeFirst();
      if (hasThrough) {
        if (node == through) {
          validPathsCount += pathsFromThrough;
          continue;
        }
      } else {
        if (node == to) {
          validPathsCount++;
          continue;
        }
      }
      if (!closure[node]!.contains(to)) {
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
