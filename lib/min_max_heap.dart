/// Dart implementation of Min-Max binary heap.
library min_max_heap;

import 'dart:math' show pow;

import 'package:min_max_heap/src/min_max_heap_base.dart';

/// A priority queue of `T` type.
/// MinMax heap is a traditional binary heap, a 'double-ended priority queue',
/// a priority queue where the elements are organized following the 2 properties of a binary heap:
/// 1. Heap shape: All levels, except the last one, are fullfilleds with max elements on the respective level.
/// 2. Min-Max heap condition: The levels alternate between Min and Max levels, where the nodes in min level are
/// less than all of his descendants (in your subtree), and in the max level, the max one in all of his descendants (in your subtree).
///
/// The getters `min` and `max` have complexity O(1), and insertion, delete (in both extremes, min or max),
/// have O(lgn)
///
/// This implementation supports generics, so you can store elements with any data type or class,
/// since you follow the rules:
/// 1. If your content has `num` type, int or double, you can, optionally, leave the callback parameter null.
/// 2. Else you need to pass a callback function whicj return type is num.
///
/// The heap will be balanced accordingly your content, if has num type and callback is null,
/// or based on the callback's result on the content.
class MinMaxHeap<T extends Object> {
  /// Internal storage of the heap.
  final List<T> _heapStorage;

  /// Callback function which will be applyied on the element.
  /// Can be null since you maybe want to build your heap based on the content.
  final num Function(T element)? _callback;

  /// Returns heap length, the number of elements present in the heap.
  int get length => _heapStorage.length;

  /// Returns the index of the last one.
  Idx get _last => length - 1;

  /// Returns the heap like a `Iterable<T>`. Perfect to loop through.
  Iterable<T> get iterable => _heapStorage.map((e) => e);

  /// Heap with list shape.
  List<T> get listMode => [for (final element in _heapStorage) element];

  /// Root's index.
  Idx get _root => 0;

  /// Access operator for the heap in List mode
  T operator [](int index) {
    return listMode[index];
  }

  /// Deepest level of the heap.
  int get depth => length.logBase2.floor();

  /// Criteria defined.
  final Criteria _criteria;

  /// Helper method to find father's node index.
  Idx _parentOf({required Idx index}) => ((index - 1) / 2).floor();

  /// Helper methos to find grandparent's node index.
  Idx _grandParentOf({required Idx index}) =>
      _parentOf(index: _parentOf(index: index));

  /// Get the level type based on index. Can be a Min level or Max level.
  HeapLevel _levelTypeOf({required Idx index}) =>
      (index + 1).logBase2.floor().isEven ? HeapLevel.min : HeapLevel.max;

  /// You can build the heap in many ways:
  /// 1. Passing a [input] `List<T>`.
  ///
  /// 1.1 If [criteria] is equal to null, the content type of your list should be a `num`, like `int` or `double`.
  ///
  /// 1.2 Otherwise, your [criteria] callback function should return a `num` type. The heap will balance based on this callback on the element.
  ///
  /// 2. You can omit the [input] parameter, and build your heap with the `insert` method,
  /// but you need to follow the criteria above, if your type is `num`, you can omit the [criteria], otherwise, you need to pass
  /// a callback with return type equal to `num`.
  MinMaxHeap({List<T>? input, num Function(T element)? criteria})
      : _heapStorage = input?.map((e) => e).toList() ?? [],
        _callback = criteria,
        _criteria = criteria != null ? Criteria.callback : Criteria.content {
    if (_heapStorage.isNotEmpty) {
      if (_callback == null && !(T is! num || T is! int || T is! double)) {
        throw ArgumentError('Content isnt a num type');
      } else {
        for (Idx i = _parentOf(index: _last); i >= _root; i--) {
          _trickleDown(index: i);
        }
      }
    }
  }

  void _trickleDown({required Idx index}) {
    if (_levelTypeOf(index: index) == HeapLevel.min) {
      _trickleDownMin(index: index);
    } else {
      _trickleDownMax(index: index);
    }
  }

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

  void _bubbleUpMin({required Idx index}) {
    if (_grandParentOf(index: index) >= _root) {
      if (_getValue(index: index) <
          _getValue(index: _grandParentOf(index: index))) {
        _swap(first: index, second: _grandParentOf(index: index));
        _bubbleUpMin(index: _grandParentOf(index: index));
      }
    }
  }

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
    final T temp = _heapStorage[first];
    _heapStorage[first] = _heapStorage[second];
    _heapStorage[second] = temp;
  }

  /// Children and Grandchildren indexes, even if
  /// doesn't exists.
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

  num _getValue({required Idx index}) {
    if (_criteria == Criteria.content) {
      return _heapStorage[index] as num;
    } else {
      if (_callback != null) {
        return _callback!(_heapStorage[index]);
      } else {
        throw Error();
      }
    }
  }

  void insert(T element) {
    _heapStorage.add(element);
    _bubbleUp(index: _last);
  }

  T removeMin() {
    late final T elementToBeRemoved;
    switch (length) {
      case 0:
        throw Exception('Empty heap');
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

  T removeMax() {
    late final T elementToBeRemoved;
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

  T get min => switch (length) {
        >= 1 => _heapStorage[_root],
        _ => throw Exception('Empty heap')
      };

  T get max => switch (length) {
        >= 3 => _getValue(index: 1) > _getValue(index: 2)
            ? _heapStorage[1]
            : _heapStorage[2],
        2 => _heapStorage[1],
        1 => _heapStorage[_root],
        _ => throw Exception('Empty heap')
      };

  void _printLevel({
    required int level,
    Object Function(T element)? callback,
  }) {
    print('Level $level - ${level.isEven ? 'min' : 'max'}: ${[
      for (Idx i = (pow(2, level) - 1).toInt();
          (i < pow(2, level + 1) - 1) && (i <= _last);
          i++)
        callback != null ? callback(_heapStorage[i]) : _heapStorage[i]
    ].join('|')}');
  }

  void printTree({Object Function(T element)? criteria}) {
    for (int i = 0; i <= depth; i++) {
      _printLevel(level: i, callback: criteria);
    }
  }
}
