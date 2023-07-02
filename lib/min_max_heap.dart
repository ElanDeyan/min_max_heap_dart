/// Dart implementation of Min-Max binary heap.
/// You need to attend the following rules:
/// 1. The input type should be a list of non-nullables objects.
/// 2. The callback function should return a num value.
/// 3. If you want to work only with your values, leave criteria callback as null
/// and use a input list of num values.
library min_max_heap;

import 'dart:math' show pow;

import 'package:logging/logging.dart';

import 'package:min_max_heap/src/min_max_heap_base.dart';

export 'package:min_max_heap/src/min_max_heap_base.dart';

final Logger log = Logger('MinMax heap');

class MinMaxHeap<T extends Object> {
  final List<HeapNode<T>> _heapStorage;

  final num Function(T element)? _callback;

  int get length => _heapStorage.length;

  Idx get _last => length - 1;

  List<T> get toList => [for (final heapNode in _heapStorage) heapNode.content];

  Idx get _root => 0;

  HeapNode<T> operator [](int index) {
    return _heapStorage[index];
  }

  int get depth => length.logBase2.floor();

  final Criteria _criteria;

  Idx _parentOf({required Idx index}) => ((index - 1) / 2).floor();

  Idx _grandParentOf({required Idx index}) =>
      _parentOf(index: _parentOf(index: index));

  HeapLevel _levelTypeOf({required Idx index}) =>
      (index + 1).logBase2.floor().isEven ? HeapLevel.min : HeapLevel.max;

  MinMaxHeap({List<T>? input, num Function(T element)? criteria})
      : _heapStorage =
            input?.map((e) => HeapNode<T>(content: e)).toList() ?? [],
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
    final HeapNode<T> temp = _heapStorage[first];
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
      return _heapStorage[index].content as num;
    } else {
      if (_callback != null) {
        return _callback!(_heapStorage[index].content);
      } else {
        throw Error();
      }
    }
  }

  void insert(T element) {
    _heapStorage.add(HeapNode<T>(content: element));
    _bubbleUp(index: _last);
  }

  T removeMin() {
    late final T elementToBeRemoved;
    switch (length) {
      case 0:
        throw Exception('Empty heap');
      case 1:
        elementToBeRemoved = _heapStorage[_root].content;
        _heapStorage.removeLast();
      default:
        elementToBeRemoved = _heapStorage[_root].content;
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
        elementToBeRemoved = _heapStorage[_root].content;
        _heapStorage.removeLast();
      case 2:
        elementToBeRemoved = _heapStorage[1].content;
        _heapStorage.removeLast();
      default:
        final Idx max = _getValue(index: 1) > _getValue(index: 2) ? 1 : 2;
        elementToBeRemoved = _heapStorage[max].content;
        _swap(first: max, second: _last);
        _heapStorage.removeLast();
        _trickleDown(index: max);
    }
    return elementToBeRemoved;
  }

  T get min => switch (length) {
        >= 1 => _heapStorage[_root].content,
        _ => throw Exception('Empty heap')
      };

  T get max => switch (length) {
        >= 3 => _getValue(index: 1) > _getValue(index: 2)
            ? _heapStorage[1].content
            : _heapStorage[2].content,
        2 => _heapStorage[1].content,
        1 => _heapStorage[_root].content,
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
        callback != null ? callback(_heapStorage[i].content) : _heapStorage[i].content
    ].join('|')}');
  }

  void printTree({Object Function(T element)? criteria}) {
    for (int i = 0; i <= depth; i++) {
      _printLevel(level: i, callback: criteria);
    }
  }
}
