import '../utils/index.dart';

class Day06 extends GenericDay {
  Day06() : super(6);

  @override
  (Field<int>, List<String>) parseInput() {
    final [...numbers, operations] = input.getPerLine();
    final numberField = Field<int>(
      numbers.map((e) {
        return e.trim().split(RegExp(r'\s+')).map(int.parse).toList();
      }).toList(),
    );
    return (numberField, operations.trim().split(RegExp(r'\s+')));
  }

  @override
  int solvePart1() {
    final (numbers, operations) = parseInput();
    final columns = numbers.columns;
    return operations.foldIndexed(0, (index, previous, operation) {
      if (operation == '+') {
        return previous +
            columns[index].fold(0, (previousValue, element) {
              return previousValue + element;
            });
      }
      return previous +
          columns[index].fold(1, (previousValue, element) {
            return previousValue * element;
          });
    });
  }

  @override
  int solvePart2() {
    final [...numbers, lastLine] = input.getPerLine();
    final operations = lastLine.split('');
    final charField = Field<String>(numbers.map((e) => e.split('')).toList());
    final operationIndices = <Range, String>{};
    var index = 0;
    while (index < operations.length) {
      final operation = operations[index];
      if (operation == '+' || operation == '*') {
        final firstIndex = index;
        while (index < operations.length) {
          index++;
          if (index + 1 >= operations.length) {
            operationIndices[(firstIndex, operations.length - 1)] = operation;
          } else if (operations[index + 1] != ' ') {
            operationIndices[(firstIndex, index - 1)] = operation;
            break;
          }
        }
      }
      index++;
    }
    var result = 0;
    for (final MapEntry(key: (x, y), value: operation)
        in operationIndices.entries) {
      if (operation == '+') {
        var sum = 0;
        for (var i = x; i <= y; i++) {
          sum += int.parse(charField.getColumn(i).join().replaceAll(' ', ''));
        }
        result += sum;
      } else {
        var product = 1;
        for (var i = x; i <= y; i++) {
          product *= int.parse(
            charField.getColumn(i).join().replaceAll(' ', ''),
          );
        }
        result += product;
      }
    }

    return result;
  }
}
