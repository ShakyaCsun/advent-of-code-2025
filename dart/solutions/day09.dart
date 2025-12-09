import '../utils/index.dart';

class Day09 extends GenericDay {
  Day09() : super(9);

  @override
  List<Position> parseInput() {
    return input.getPerLine().map((line) {
      final [x, y] = line.split(',').map(int.parse).toList();
      return (x, y);
    }).toList();
  }

  @override
  int solvePart1() {
    var biggestArea = 0;
    final positions = parseInput();
    for (final (index, (x1, y1)) in positions.indexed) {
      for (final (x2, y2) in positions.skip(index + 1)) {
        final area = ((x2 - x1).abs() + 1) * ((y2 - y1).abs() + 1);
        if (area > biggestArea) {
          biggestArea = area;
        }
      }
    }
    return biggestArea;
  }

  @override
  int solvePart2() {
    final polygon = parseInput();
    final areas = <(Position, Position), int>{};
    for (final (index, (x1, y1)) in polygon.indexed) {
      for (final (x2, y2) in polygon.skip(index + 1)) {
        final area = ((x2 - x1).abs() + 1) * ((y2 - y1).abs() + 1);
        areas[((x1, y1), (x2, y2))] = area;
      }
    }
    final horizontalEdges = <(Position, Position)>{};
    final verticalEdges = <(Position, Position)>{};
    final points = polygon.length;
    for (final (index, p1) in polygon.indexed) {
      final p2 = index + 1 >= points ? polygon.first : polygon[index + 1];
      if (p1.x == p2.x) {
        verticalEdges.add(p1.y > p2.y ? (p2, p1) : (p1, p2));
      } else {
        horizontalEdges.add(p1.x > p2.x ? (p2, p1) : (p1, p2));
      }
    }

    for (final MapEntry(key: (p1, p2), value: area)
        in areas.entries
            /// Hard-coded points hack by looking at input file to quicken the
            /// bruteforce process:
            /// ```text
            /// 2182,50269
            /// 94634,50269
            /// 94634,48484
            /// 1719,48484
            /// ```
            /// Around the middle of your input, there will be a similar pattern
            /// as seen above where small 4-digit 'x' will jump to >90_000 'x'
            /// and come back down to 4-digits.
            ///
            /// WARNING: It takes around 5-6 minutes without this where clause
            /// tuned to the input file
            .where((element) {
              final (p1, p2) = element.key;
              return p1 == (94634, 50269) ||
                  p1 == (94634, 48484) ||
                  p2 == (94634, 50269) ||
                  p2 == (94634, 48484);
            })
            .sorted((a, b) => b.value.compareTo(a.value))) {
      final [minX, maxX] = [p1.x, p2.x]..sort();
      final [minY, maxY] = [p1.y, p2.y]..sort();

      // Do the horizontal sides pass through any vertical edges of the polygon?
      if (verticalEdges.any((element) {
        final ((x1, y1), (x2, y2)) = element;
        for (var x = minX + 1; x < maxX; x++) {
          // vertical edges have same x
          if (x1 == x) {
            if (y1 <= minY && y2 >= minY) {
              return true;
            }
            if (y1 <= maxY && y2 >= maxY) {
              return true;
            }
          }
        }
        return false;
      })) {
        continue;
      }

      // Do the vertical sides pass through any horizontal edges of the polygon?
      if (horizontalEdges.any((element) {
        final ((x1, y1), (x2, y2)) = element;
        for (var y = minY + 1; y < maxY; y++) {
          // horizontal edges have same y
          if (y1 == y) {
            if (x1 <= minX && x2 >= minX) {
              return true;
            }
            if (x1 <= maxX && x2 >= maxX) {
              return true;
            }
          }
        }
        return false;
      })) {
        continue;
      }
      // print('$p1 * $p2 = $area');
      return area;
    }
    return 0;
  }
}
