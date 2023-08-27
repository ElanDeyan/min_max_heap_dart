/// Dart implementation of Min-Max binary heap.
library min_max_heap;

import 'dart:math' show pow;
import 'package:logging/logging.dart';

import 'package:min_max_heap/src/min_max_heap_base.dart';

/// A double-ended priority queue of `E` type.
/// 
/// Suggestion: When import this class, give the alias 'PriorityDeque'.
/// 
/// MinMax heap is a traditional binary heap, a 'double-ended priority queue',
/// a priority queue where the elements are organized following the 2 properties of a binary heap:
/// 1. Heap shape: All levels, except the last one, are fullfilleds with max elements on the respective level.
/// 2. Min-Max heap condition: The levels alternate between Min and Max levels, where the nodes in min level are
/// less than all of his descendants (in your subtree), and in the max level, the max one in all of his descendants (in your subtree).
///
/// The getters `min` and `max` have complexity O(1), and insertion, delete (in both extremes, min or max),
/// have O(lg n)
///
/// This implementation supports generics, so you can store elements with any data type or class,
/// since you follow the rules:
/// 1. If your content has `num` type, int or double, you can, optionally, leave the callback parameter null.
/// 2. Else you need to pass a callback function whicj return type is num.
///
/// The heap will be balanced accordingly your content, if has num type and callback is null,
/// or based on the callback's result on the content.
class MinMaxHeap<E extends Object> {
  /// Build a min-max heap, a double-ended priority queue.
  /// If [criteria] is equal to null, the content type of your list should be a `num`, like `int` or `double`.
  /// Otherwise, your [criteria] callback function should return a `num` type.
  /// The heap will adjust based on this callback applyied on the element.
  MinMaxHeap({
    num Function(E element)? criteria,
  })  : _callback = criteria,
        _isContentCriteria = criteria == null,
        _heapStorage = <E>[];

  /// Build a min-max heap, a double-ended priority queue, from an [iterable].
  /// If [criteria] is equal to null, the content type of your list should be a `num`, like `int` or `double`.
  /// Otherwise, your [criteria] callback function should return a `num` type.
  /// The heap will adjust based on this callback applyied on the element.
  factory MinMaxHeap.fromIterable({
    required Iterable<E> iterable,
    num Function(E element)? criteria,
  }) {
    final isContentCriteria = criteria == null;
    if (isContentCriteria && !isNumericalType(iterable)) {
      throw ArgumentError.value(
        iterable,
        null,
        "If you want a content criteria, send a iterable of num's.",
      );
    } else {
      final newHeap = MinMaxHeap(criteria: criteria);
      newHeap.enqueueAll(iterable);
      return newHeap;
    }
  }

  /// Internal storage of the heap. Stored as a [List].
  List<E> _heapStorage;

  /// Callback function which will be applyied on the element.
  /// Can be null if you want to build your heap based on the numerical content.
  /// Internally, the class will call this function to compare the result between two
  /// values and, accordingly, organize the [_heapStorage].
  final num Function(E element)? _callback;

  /// Returns heap [length], the number of elements present in the [_heapStorage].
  int get length => _heapStorage.length;

  /// Check when the [_heapStorage] is empty.
  bool get isEmpty => _heapStorage.isEmpty;

  /// Check when the [_heapStorage] is not empty.
  bool get isNotEmpty => _heapStorage.isNotEmpty;

  /// Index of the last element in [_heapStorage].
  Idx get _last => length - 1;

  /// Index of the last element with a child.
  Idx get _lastFather => (length - 1) ~/ 2;

  /// A lazy iterable of the heap in [Iterable] shape. Perfect to loop through.
  Iterable<E> get iterable sync* {
    for (final element in _heapStorage) {
      yield element;
    }
  }

  /// Elements in [List] shape. To view the elements by level, see [logTree] or [asMapOfLevels].
  List<E> get asList => iterable.toList();

  /// Return a lazy iterable of the heap in decreasing or ascending order.
  /// Default [isAscendingOrder].
  Iterable<E> sortedView({bool isAscendingOrder = true}) sync* {
    if (isAscendingOrder) {
      while (isNotEmpty) {
        yield dequeueMin;
      }
    } else {
      while (isNotEmpty) {
        yield dequeueMax;
      }
    }
  }

  /// Root's index.
  Idx get _root => 0;

  /// Deepest level of the heap.
  int get depth => length.logBase2.floor();

  /// Criteria defined. Based on the content or [_callback].
  final bool _isContentCriteria;

  /// Helper method to find father's node by [index].
  Idx _parentOf({required Idx index}) => ((index - 1) / 2).floor();

  /// Helper method to find grandparent's node by [index].
  Idx _grandParentOf({required Idx index}) => _parentOf(
        index: _parentOf(
          index: index,
        ),
      );

  /// Helper method to get the level type based on [index].
  /// Can be a Min level or Max level.
  HeapLevel _levelTypeOf({required Idx index}) =>
      (index + 1).logBase2.floor().isEven ? HeapLevel.min : HeapLevel.max;

  /// Checks the [_levelTypeOf] of [index] and calls [_trickleDownMin] or [_trickleDownMax], based on the level.
  void _trickleDown({required Idx index}) {
    if (_levelTypeOf(index: index) == HeapLevel.min) {
      _trickleDownMin(index: index);
    } else {
      _trickleDownMax(index: index);
    }
  }

  /// AKA percolate down, will get the smallest children or grandchildren of [index] in min level
  /// and checks if is child or not.
  ///
  /// After, will make comparisons to correct the heap condition, make the nodes
  /// at min levels be the minimum ones of his own subtree, and max level nodes,
  /// the max of his subtree.
  void _trickleDownMin({required Idx index}) {
    final Idx lastChild = 2 * index + 2;
    if (index <= _parentOf(index: _last)) {
      final Iterable<Idx> descendants = _descendantsOf(index: index);
      final Idx smallest = descendants.fold(
        descendants.first,
        (previousValue, element) =>
            _getValue(index: element) < _getValue(index: previousValue)
                ? element
                : previousValue,
      );
      final bool isGrandchild = smallest > lastChild;

      if (isGrandchild) {
        if (_getValue(index: smallest) < _getValue(index: index)) {
          _swap(first: smallest, second: index);
          if (_getValue(index: smallest) >
              _getValue(index: _parentOf(index: smallest))) {
            _swap(first: smallest, second: _parentOf(index: smallest));
          }
          _trickleDown(index: smallest);
        }
      } else {
        if (_getValue(index: smallest) < _getValue(index: index)) {
          _swap(first: smallest, second: index);
        }
      }
    }
  }

  /// AKA percolate down, will get the smallest children or grandchildren
  /// of [index] in max level and checks if is child or not.
  ///
  /// After, will make comparisons to correct the heap condition, make the nodes
  /// at min levels be the minimum ones of his own subtree, and max level nodes,
  /// the max of his subtree.
  void _trickleDownMax({required Idx index}) {
    final Idx lastChild = 2 * index + 2;
    if (index <= _parentOf(index: _last)) {
      final Iterable<Idx> descendants = _descendantsOf(index: index);
      final Idx largest = descendants.fold(
        descendants.first,
        (previousValue, element) =>
            _getValue(index: element) > _getValue(index: previousValue)
                ? element
                : previousValue,
      );
      final bool isGrandchild = largest > lastChild;

      if (isGrandchild) {
        if (_getValue(index: largest) > _getValue(index: index)) {
          _swap(first: largest, second: index);
          if (_getValue(index: largest) <
              _getValue(index: _parentOf(index: largest))) {
            _swap(first: largest, second: _parentOf(index: largest));
          }
          _trickleDown(index: largest);
        }
      } else {
        if (_getValue(index: largest) > _getValue(index: index)) {
          _swap(first: largest, second: index);
        }
      }
    }
  }

  /// Litteraly bubble up the node to his correct place,
  /// respecting the heap condition.
  /// Essential in [insert] and [enqueue] methods.
  void _bubbleUp({required Idx index}) {
    if (_levelTypeOf(index: index) == HeapLevel.min) {
      if (_parentOf(index: index) >= _root) {
        if (_getValue(index: index) >
            _getValue(index: _parentOf(index: index))) {
          _swap(first: index, second: _parentOf(index: index));
          _bubbleUpMax(index: _parentOf(index: index));
        }
        _bubbleUpMin(index: index);
      }
    } else {
      if (_parentOf(index: index) >= _root) {
        if (_getValue(index: index) <
            _getValue(index: _parentOf(index: index))) {
          _swap(first: index, second: _parentOf(index: index));
          _bubbleUpMin(index: _parentOf(index: index));
        }
        _bubbleUpMax(index: index);
      }
    }
  }

  /// Correct cases when a node at [index] is less than his grandparent.
  void _bubbleUpMin({required Idx index}) {
    if (_grandParentOf(index: index) >= _root) {
      if (_getValue(index: index) <
          _getValue(index: _grandParentOf(index: index))) {
        _swap(first: index, second: _grandParentOf(index: index));
        _bubbleUpMin(index: _grandParentOf(index: index));
      }
    }
  }

  /// Correct cases when a node at [index] is higher than his grandparent.
  void _bubbleUpMax({required Idx index}) {
    if (_grandParentOf(index: index) >= _root) {
      if (_getValue(index: index) >
          _getValue(index: _grandParentOf(index: index))) {
        _swap(first: index, second: _grandParentOf(index: index));
        _bubbleUpMax(index: _grandParentOf(index: index));
      }
    }
  }

  /// Swap the values presents on the respectives indexes.
  void _swap({required Idx first, required Idx second}) {
    final E temp = _heapStorage[first];
    _heapStorage[first] = _heapStorage[second];
    _heapStorage[second] = temp;
  }

  /// Helper method to get the children and grandchildren indexes, given an [index], even if
  /// doesn't have children or grandchildren.
  /// The `where` method will filter them.
  Iterable<Idx> _descendantsOf({required Idx index}) {
    final Iterable<Idx> descendants = [
      2 * index + 1,
      2 * index + 2,
      4 * index + 3,
      4 * index + 4,
      4 * index + 5,
      4 * index + 6,
    ];
    return descendants.where((i) => i <= _last);
  }

  /// Check the criteria chased by user in [_callback] value,
  /// being `null` or not, and gets the value at [index].
  ///
  /// If the content is a non numerical type, this method will use the user's callback
  /// to get the numerical correct value.
  /// See [_callback] for more details.
  num _getValue({required Idx index}) {
    if (_isContentCriteria) {
      return _heapStorage[index] as num;
    } else {
      return _callback!(_heapStorage[index]);
    }
  }

  /// Insert [element] at the end of internal list, and bubble up the node.
  /// Since `2.0.0`, alias for the [enqueue] getter.
  void insert(E element) {
    enqueue(element);
  }

  /// Enqueue [element] at the end, and [_bubbleUp] the element.
  ///
  /// Since `2.0.0`, replace the [insert] method. They do the same.
  void enqueue(E element) {
    _heapStorage.add(element);
    _bubbleUp(index: _last);
  }

  /// Enqueue all elements of the [iterable] at the end,
  /// and uses floyd's build heap algorithm, [_trickleDown] to adjust the heap.
  void enqueueAll(Iterable<E> iterable) {
    _heapStorage.addAll(iterable);
    for (var i = _lastFather; i >= 0; i--) {
      _trickleDown(index: i);
    }
  }

  /// Remove the minimum value in the heap.
  ///
  /// Throws [Exception] if the heap [isEmpty].
  ///
  /// Since `2.0.0`, [removeMin] still working, but is alias for [dequeueMin].
  E removeMin() {
    return dequeueMin;
  }

  /// Dequeue the minimum value in the priority deque.
  ///
  /// Throws [Exception] if the heap [isEmpty].
  ///
  /// Since `2.0.0`, replace [removeMin] method. [removeMin] still working,
  /// but is alias for this getter.
  E get dequeueMin {
    late final E elementToBeRemoved;
    switch (length) {
      case 0:
        throw StateError('Empty heap');
      case 1:
        elementToBeRemoved = _heapStorage[_root];
        _heapStorage.removeLast();
      default:
        elementToBeRemoved = _heapStorage[_root];
        _swap(first: _root, second: _last);
        _heapStorage.removeLast();
        _trickleDown(index: _root);
    }
    return elementToBeRemoved;
  }

  /// Equivalent to [dequeueMin] getter, but returns `null` if [isEmpty].
  E? get tryDequeueMin {
    try {
      return dequeueMin;
    } on StateError {
      return null;
    }
  }

  /// Remove the maximum element in the heap.
  ///
  /// Throws [Exception] if the heap [isEmpty].
  ///
  /// Since `2.0.0`, [removeMax] still working, but is alias for [dequeueMax].
  E removeMax() {
    return dequeueMax;
  }

  /// Dequeue the element with max priority in the heap.
  ///
  /// Throws [Exception] if the heap [isEmpty].
  ///
  /// Since `2.0.0`, replace [removeMax] method. [removeMax] still working,
  /// but is alias for this getter.
  E get dequeueMax {
    late final E elementToBeRemoved;
    switch (length) {
      case 0:
        throw Exception('Empty heap');
      case 1:
        elementToBeRemoved = _heapStorage[_root];
        _heapStorage.removeLast();
      case 2:
        elementToBeRemoved = _heapStorage[1];
        _heapStorage.removeLast();
      default:
        final Idx max = _getValue(index: 1) > _getValue(index: 2) ? 1 : 2;
        elementToBeRemoved = _heapStorage[max];
        _swap(first: max, second: _last);
        _heapStorage.removeLast();
        _trickleDown(index: max);
    }
    return elementToBeRemoved;
  }

  /// Equivalent to [dequeueMin] getter, but returns `null` if [isEmpty].
  E? get tryDequeueMax {
    try {
      return dequeueMax;
    } on StateError {
      return null;
    }
  }

  /// The min value of the heap.
  ///
  /// Throws [Exception] if the heap [isEmpty].
  E get min => switch (length) {
        >= 1 => _heapStorage[_root],
        _ => throw StateError('Empty heap')
      };

  E? get tryMin {
    try {
      return min;
    } on StateError {
      return null;
    }
  }

  /// Gets the max value in the heap.
  ///
  /// Throws [Exception] if the [_heapStorage.isEmpty].
  E get max => switch (length) {
        >= 3 => _getValue(index: 1) > _getValue(index: 2)
            ? _heapStorage[1]
            : _heapStorage[2],
        2 => _heapStorage[1],
        1 => _heapStorage[_root],
        _ => throw StateError('Empty heap')
      };

  E? get tryMax {
    try {
      return max;
    } on StateError {
      return null;
    }
  }

  /// A map with the keys as levels of the heap, and value 
  /// as an [List] with the elements presents in this level.
  Map<int, List<E>> get asMapOfLevels => <int, List<E>>{
        for (var level = 0; level <= depth; level++)
          level: [
            for (var i = (pow(2, level) - 1).toInt();
                (i < pow(2, level + 1) - 1) && (i <= _last);
                i++)
              _heapStorage[i],
          ],
      };

  /// Private helper to print elements in each [level].
  ///
  /// Can use a [_callback] to print user's defined value.
  void _logLevel({
    required int level,
    Object Function(E element)? callback,
  }) {
    final logger = Logger('Heap levels');
    logger.info('Level $level - ${level.isEven ? 'min' : 'max'}: ${[
      for (Idx i = (pow(2, level) - 1).toInt();
          (i < pow(2, level + 1) - 1) && (i <= _last);
          i++)
        callback != null ? callback(_heapStorage[i]) : _heapStorage[i],
    ].join('|')}');
  }

  /// Prints a "tree" representation of the heap.
  /// Is an approach to see elements in each level.
  /// Can use a new custom [criteria] function to see the elements based on your preference.
  /// Uses [_logLevel].
  void logTree({Object Function(E element)? criteria}) {
    for (int i = 0; i <= depth; i++) {
      _logLevel(level: i, callback: criteria);
    }
  }
}
