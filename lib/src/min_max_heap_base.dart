import 'dart:math' show log;

typedef Idx = int;

bool isNumericalType(Object object) {
  if (object is Iterable) {
    return object is Iterable<num> ||
        object is Iterable<int> ||
        object is Iterable<double>;
  } else {
    return object is num || object is int || object is double;
  }
}

/// Helper method to get the level type based on [index].
/// Min levels are even numbers and max levels are odd numbers.
bool isMinLevel({required Idx index}) => (index + 1).logBase2.floor().isEven;

extension MathExtensions on num {
  num get logBase2 => log(this) / log(2);
}
