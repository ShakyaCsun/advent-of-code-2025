import 'package:equatable/equatable.dart';
import 'package:z3/z3.dart' as z3;

import '../utils/index.dart';

class Day10 extends GenericDay {
  Day10() : super(10);

  @override
  List<InitializationManual> parseInput() {
    return input.getPerLine().map(InitializationManual.fromLine).toList();
  }

  @override
  int solvePart1() {
    final manuals = parseInput();
    return manuals.fold(0, (previousValue, element) {
      return previousValue + element.partOne();
    });
  }

  @override
  int solvePart2() {
    final manuals = parseInput();
    return manuals.fold(0, (previousValue, element) {
      return previousValue + element.partTwo();
    });
  }
}

class InitializationManual extends Equatable {
  const InitializationManual({
    required this.indicatorLights,
    required this.buttonSchematics,
    required this.joltageRequirements,
  }) : numberOfMachines = indicatorLights.length;

  factory InitializationManual.fromLine(String line) {
    final [indicator, ...buttons, joltage] = line.split(' ');
    final indicatorLights = indicator
        .substring(1, indicator.length - 1)
        .split('')
        .map((char) => char == '#')
        .toList();
    final buttonSchematics = buttons.map((e) {
      return e.substring(1, e.length - 1).split(',').map(int.parse).toSet();
    }).toList();
    final joltageRequirements = joltage
        .substring(1, joltage.length - 1)
        .split(',')
        .map(int.parse)
        .toList();
    return InitializationManual(
      indicatorLights: indicatorLights,
      buttonSchematics: buttonSchematics,
      joltageRequirements: joltageRequirements,
    );
  }

  final List<bool> indicatorLights;
  final List<Set<int>> buttonSchematics;
  final List<int> joltageRequirements;
  final int numberOfMachines;

  static List<bool> toggleButton(
    Set<int> button, {
    required List<bool> initialState,
  }) {
    return initialState.mapIndexed((index, element) {
      if (button.contains(index)) {
        return !element;
      }
      return element;
    }).toList();
  }

  static List<int> joltageButton(
    Set<int> button, {
    required List<int> initialState,
  }) {
    return initialState.mapIndexed((index, element) {
      if (button.contains(index)) {
        return element + 1;
      }
      return element;
    }).toList();
  }

  int partOne() {
    final currentState = List.filled(numberOfMachines, false);
    final cacheMemo = IndicatorLightsSet.from([currentState]);

    IndicatorLightsSet pressAllOnce({required List<bool> state}) {
      final newStates = IndicatorLightsSet();
      for (final button in buttonSchematics) {
        final nextState = toggleButton(button, initialState: state);
        if (!cacheMemo.contains(nextState)) {
          newStates.add(nextState);
          cacheMemo.add(nextState);
        }
      }
      return newStates;
    }

    var currentStates = IndicatorLightsSet.from([currentState]);
    var currentButtonPresses = 0;
    while (!currentStates.contains(indicatorLights)) {
      currentButtonPresses++;
      final nextStates = IndicatorLightsSet();
      for (final state in currentStates) {
        nextStates.addAll(pressAllOnce(state: state));
      }
      currentStates = nextStates;
    }
    return currentButtonPresses;
  }

  int partTwo() {
    final numberOfButtons = joltageButtons.length;
    final buttonPressVars = [
      for (var i = 0; i < numberOfButtons; i++)
        z3.constVar('btn-$i', z3.intSort),
    ];
    final solver = z3.optimize();
    for (final (answerIndex, answer) in joltageRequirements.indexed) {
      z3.Expr? expression;
      for (final (index, button) in buttonPressVars.indexed) {
        if (joltageButtons[index][answerIndex] == 1) {
          if (expression == null) {
            expression = button;
          } else {
            expression += button;
          }
        }
      }
      if (expression case final expression?) {
        // print(expression);
        solver.add(expression.eq(answer));
      }
    }
    for (final button in buttonPressVars) {
      solver.add(button.betweenIn(0, joltageRequirements.max));
    }
    z3.Expr buttonPressesTotal = buttonPressVars.first;
    for (final button in buttonPressVars.skip(1)) {
      buttonPressesTotal += button;
    }
    solver.minimize(buttonPressesTotal);
    if (solver.check() ?? false) {
      final model = solver.getModel();
      final buttonPresses = buttonPressVars.map((element) {
        return model[element].toInt();
      });
      final finalStateOfMachines = buttonPresses.foldIndexed<List<int>>(
        List.filled(numberOfMachines, 0),
        (index, previous, buttonPress) {
          return previous.addJoltage(
            joltageButtons[index].multiply(buttonPress),
          );
        },
      );
      if (!const ListEquality<int>().equals(
        finalStateOfMachines,
        joltageRequirements,
      )) {
        throw StateError(
          'Produced solution is not correct.\n'
          'Expected: $joltageRequirements\nActual: $finalStateOfMachines',
        );
      }
      return buttonPresses.fold(
        0,
        (previousValue, element) => previousValue + element,
      );
    }
    throw StateError('No solutions found');
  }

  bool isJoltageValid(List<int> joltageState) {
    for (final (index, joltage) in joltageState.indexed) {
      if (joltage > joltageRequirements[index]) {
        return false;
      }
    }
    return true;
  }

  List<List<int>> get joltageButtons {
    return buttonSchematics
        .map(
          (button) => List.generate(numberOfMachines, (index) {
            if (button.contains(index)) {
              return 1;
            }
            return 0;
          }),
        )
        .toList();
  }

  @override
  List<Object> get props => [
    indicatorLights,
    buttonSchematics,
    joltageRequirements,
  ];
}

class IndicatorLightsSet extends EqualitySet<List<bool>> {
  IndicatorLightsSet() : super(const ListEquality<bool>());
  IndicatorLightsSet.from(Iterable<List<bool>> other)
    : super.from(const ListEquality(), other);
}

class JoltagesSet extends EqualitySet<List<int>> {
  JoltagesSet() : super(const ListEquality<int>());
  JoltagesSet.from(Iterable<List<int>> other)
    : super.from(const ListEquality(), other);
}

extension on List<int> {
  List<int> addJoltage(List<int> other) {
    return other.mapIndexed((index, element) => element + this[index]).toList();
  }

  List<int> multiply(int presses) {
    return map((e) => e * presses).toList();
  }
}
