import 'dart:math' show log;

typedef Idx = int;

enum HeapLevel { min, max }

enum Criteria { content, callback }

extension MathExtensions on num {
  num get logBase2 => log(this) / log(2);
}

class HeapNode<T extends Object> {
  T content;

  HeapNode({required this.content});
}
