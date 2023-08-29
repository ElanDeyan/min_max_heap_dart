import 'dart:math';

import 'package:min_max_heap/min_max_heap.dart';
import 'package:test/test.dart';

typedef PriorityDeque<E extends Object> = MinMaxHeap<E>;

void main() {
  group('Storing lements', () {
    final simpleHeap = PriorityDeque<int>();
    final dataToAdd = [for (var i = 0; i < 5; i++) Random().nextInt(50)];

    test('Fullfiness of heap', () {
      expect(simpleHeap.isEmpty, true);

      expect(simpleHeap.isNotEmpty, false);

      expect(simpleHeap.length, 0);

      simpleHeap.enqueueAll(dataToAdd);

      expect(simpleHeap.isEmpty, false);

      expect(simpleHeap.isNotEmpty, true);

      expect(simpleHeap.length, 5);
    });
  });

  group('Adding data', () {
    final dataToAdd = [for (var i = 0; i < 5; i++) Random().nextInt(50)];
    test('Adding from iterable', () {
      final anotherSimpleHeap = PriorityDeque<int>.fromIterable(
        iterable: dataToAdd,
      );

      expect(anotherSimpleHeap.isEmpty, false);
      expect(anotherSimpleHeap.length, 5);
    });

    test('Non-numeric data', () {
      final stringDeque =
          PriorityDeque<String>(criteria: (word) => word.length);

      stringDeque.enqueueAll(['a', 'ab', 'abc', 'abcd', 'abcde']);

      expect(stringDeque.min.runtimeType, String);

      expect(
        stringDeque.min,
        'a',
        reason: 'The "a" string has the minimum length.',
      );
      expect(
        stringDeque.max,
        'abcde',
        reason: 'The "abcde" has the major length.',
      );
    });
  });

  group('Enqueue and dequeue', () {
    final testData = [for (var i = 0; i < 10; i++) Random().nextDouble() * 10];
    group('Enqueue', () {
      test('Single enqueue', () {
        final doubleDeque = PriorityDeque<double>();

        doubleDeque.enqueue(testData.first);

        expect(doubleDeque.length, 1);
      });

      test('More enqueues', () {
        final doubleDeque1 =
            PriorityDeque<double>.fromIterable(iterable: testData);
        
        expect(doubleDeque1.length, 10);
        
        final doubleDeque2 = PriorityDeque<double>();
        
        testData.forEach(doubleDeque2.enqueue);

        // Fun fact: build with sucessive enqueues will
        // create a different heap than using `fromIterable`
        // and `enqueueAll`.
        // But they will be valid heaps. Don't worry :).
        expect(doubleDeque2.length, 10);
        
        final doubleDeque3 = PriorityDeque<double>();

        doubleDeque3.enqueueAll(testData);

        expect(doubleDeque3.length, 10);
      });
    });

    group('Dequeue', () => null);
  });
}
