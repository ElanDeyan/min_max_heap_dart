import 'dart:math';

import 'package:min_max_heap/min_max_heap.dart';
import 'package:min_max_heap/src/min_max_heap_base.dart';
import 'package:test/test.dart';
import './data.dart' show Task;

void main() {
  // group("Adding elements", () {
  const singleNumber = 32;
  final oneElementHeap = MinMaxHeap<int>();
  oneElementHeap.add(singleNumber);

  final anotherOneElementHeap =
      MinMaxHeap<int>.fromIterable(iterable: const [singleNumber]);

  test('Element was added?', () {
    expect(oneElementHeap.length, 1);
    expect(oneElementHeap.single, singleNumber);

    expect(anotherOneElementHeap.length, 1);
    expect(anotherOneElementHeap.single, singleNumber);
  });

  test('Adding ascending order', () {
    final oneToTen = [for (var i = 0; i < 10; i++) i];
    final ascendingHeap = MinMaxHeap<int>.fromIterable(iterable: oneToTen);

    expect(ascendingHeap.min, 0);
    expect(ascendingHeap.max, 9);

    final newAscendingOrder = [
      for (; ascendingHeap.isNotEmpty;) ascendingHeap.removeMin(),
    ];

    expect(oneToTen, newAscendingOrder);
  });

  test('Adding in descending order', () {
    final tenToOne = [for (var i = 9; i >= 0; i--) i];
    final descendingHeap = MinMaxHeap<int>.fromIterable(iterable: tenToOne);

    expect(descendingHeap.min, 0);
    expect(descendingHeap.max, 9);

    final newDescendingOrder = [
      for (; descendingHeap.isNotEmpty;) descendingHeap.removeMax(),
    ];

    expect(tenToOne, newDescendingOrder);
  });

  test('Adding another sample', () {
    const sampleData = [5, 8, 2, 12, 1, 15, 4, 10, 7, 9];
    final heap = MinMaxHeap<int>.fromIterable(iterable: sampleData);

    expect(heap.length, sampleData.length);
    expect(heap.min, 1);
    expect(heap.max, 15);
  });

  test('Adding non-numeric data type', () {
    final sample = [
      Task('Sleep', priority: 5),
      Task('Buy milk', priority: 1),
      Task('Drink water', priority: 7),
      Task('Study', priority: 5),
    ];

    final taskHeap = MinMaxHeap<Task>.fromIterable(
      iterable: sample,
      criteria: (task) => task.priority,
    );

    expect(
      taskHeap.min,
      sample[1],
      reason: 'Buy milk has less priority in this sample',
    );
    expect(
      taskHeap.max,
      sample[2],
      reason: 'Drink water has more priority in this sample.'
          'Did you drink water today?',
    );
  });
  // });

  // group('Properties and getters', () {
  const oneToTen = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  test('Depth', () {
    final heap = MinMaxHeap<int>.fromIterable(iterable: oneToTen);

    expect(heap.depth, oneToTen.length.logBase2.floor());
  });

  test('Iterable', () {
    final heap = MinMaxHeap<int>.fromIterable(iterable: oneToTen);

    expect(heap.iterable, isA<Iterable<int>>());
  });

  test('As list', () {
    final heap = MinMaxHeap<int>.fromIterable(iterable: oneToTen);

    expect(heap.asList, heap.iterable.toList());
  });

  test('Sorted', () {
    final heap = MinMaxHeap<int>.fromIterable(iterable: oneToTen);

    expect(heap.sorted().toList(), equals(oneToTen));

    expect(heap.sorted(inAscendingOrder: false), equals(oneToTen.reversed));
  });

  //   group('Removes', () {
  test('Remove min', () {
    final heap = MinMaxHeap.fromIterable(iterable: oneToTen);

    expect(heap.removeMin(), equals(1));

    expect(heap.length, equals(9));

    while (heap.isNotEmpty) {
      heap.removeMin();
    }

    expect(heap.isEmpty, isTrue);

    // expect(heap.removeMin(), throwsStateError);

    expect(heap.tryRemoveMin(), isNull);
  });

  test('Remove max', () {
    final heap = MinMaxHeap.fromIterable(iterable: oneToTen);

    expect(heap.removeMax(), equals(10));

    expect(heap.length, equals(9));

    while (heap.isNotEmpty) {
      heap.removeMax();
    }

    expect(heap.isEmpty, isTrue);

    // expect(heap.removeMax(), throwsStateError);

    expect(heap.tryRemoveMax(), isNull);
  });
  //   });

  group('Min and max', () {
    test('min and minOrNull', () {
      final heap = MinMaxHeap.fromIterable(iterable: oneToTen);
      expect(heap.min, equals(1));
      expect(
        heap.length,
        equals(oneToTen.length),
        reason: "The min and minOrNull getters doesn't remove the element.",
      );

      while (heap.isNotEmpty) {
        heap.removeMin();
      }

      expect(heap.isEmpty, isTrue);

      expect(heap.minOrNull, isNull);
    });

    test('max and maxOrNull', () {
      final heap = MinMaxHeap.fromIterable(iterable: oneToTen);
      expect(heap.max, equals(10));

      expect(
        heap.length,
        equals(oneToTen.length),
        reason: "The min getter don't remove the element.",
      );

      while (heap.isNotEmpty) {
        heap.removeMax();
      }

      expect(heap.isEmpty, isTrue);

      // expect(heap.max, throwsStateError);

      expect(heap.maxOrNull, isNull);
    });
  });

  group('Single', () {
    test('single and singleOrNull', () {
      final heap = MinMaxHeap.fromIterable(iterable: oneToTen);
      // expect(heap.single, throwsStateError);
      expect(heap.singleOrNull, isNull);

      while (heap.length > 1) {
        heap.removeMin();
      }

      expect(heap.single, equals(10));

      expect(heap.singleOrNull, equals(10));
    });
  });

  test('From a List, is a valid min-max heap?', () {
    const testCase = <int>[1, 4, -5, 6, 7, 9, 3, 40, 20, 2, 70, 100];

    expect(
      getSubtreeOf(index: 1, atList: testCase),
      equals(<int>[6, 7, 40, 20, 2, 70]),
    );

    expect(isValidMinMaxHeapListView(testCase, (element) => element as int),
        isFalse);

    final heap = MinMaxHeap.fromIterable(
      iterable: [for (var i = 0; i < 100; i++) Random().nextInt(100)],
    );

    expect(
      isValidMinMaxHeapListView(heap.asList, (element) => element as int),
      isTrue,
    );
  });

  test('Clear', () {
    final heap = MinMaxHeap<int>.fromIterable(iterable: oneToTen);

    expect(heap.length, equals(10));

    heap.clear();

    expect(heap.length, equals(0));

    expect(heap.isEmpty, isTrue);
  });

  test('Compatibility constructor.', () {
    final compatibilityConstructor =
        MinMaxHeap<int>(input: [1, 2, 3, 4, 5, 6, 7, 8]);

    final newConstructor =
        MinMaxHeap<int>.fromIterable(iterable: [1, 2, 3, 4, 5, 6, 7, 8]);

    expect(compatibilityConstructor.iterable, equals(newConstructor.iterable));
  });

  test('Add and insert methods equivalence', () {
    final heap1 =
        MinMaxHeap<int>.fromIterable(iterable: [1, 2, 3, 4, 5, 6, 7, 8]);
    final heap2 =
        MinMaxHeap<int>.fromIterable(iterable: [1, 2, 3, 4, 5, 6, 7, 8]);

    heap1.add(-1);
    heap2.insert(-1);

    expect(heap1.min, equals(heap2.min));
  });

  test('replaceWhere', () {
    final heap = MinMaxHeap.fromIterable(iterable: oneToTen);

    expect(heap.min, equals(1));

    // This changes heap's priority.
    heap.replaceWhere((element) => element == 8, replacer: (element) => -1);

    expect(heap.min, equals(-1));
  });

  test('updateWhere', () {
    final heap = MinMaxHeap.fromIterable(
      iterable: <Task>[
        Task('Drink water', priority: 5),
        Task('Read', priority: 4),
        Task('Morning walk', priority: 3),
        Task("Review github's issues.", priority: 5),
      ],
      criteria: (element) => element.priority,
    );

    expect(heap.max.priority, equals(5));
    
    expect(heap.min.priority, equals(3));
    expect(heap.min.name, equalsIgnoringCase('Morning walk'));

    heap.updateWhere(
      (element) => element.priority == 3 || element.priority == 5,
      updater: (element) {
        if (element.priority == 3) {
          element.priority = 10;
          element.name = 'Changed!';
        }
        if (element.priority == 5) {
          element.priority = -1;
          element.name = 'Another change!';
        }
      },
    );

    expect(heap.min.priority, equals(-1));
    expect(heap.min.name, equalsIgnoringCase('Another change!'));

    expect(heap.max.priority, equals(10));
    expect(heap.max.name, equalsIgnoringCase("Changed!"));
  });
}
