import 'dart:math' show log;

typedef Idx = int;

enum HeapLevel { min, max }

bool isNumericalType(Object object) {
  if (object is Iterable) {
    return object is Iterable<num> ||
        object is Iterable<int> ||
        object is Iterable<double>;
  } else {
    return object is num || object is int || object is double;
  }
}

extension MathExtensions on num {
  num get logBase2 => log(this) / log(2);
}
