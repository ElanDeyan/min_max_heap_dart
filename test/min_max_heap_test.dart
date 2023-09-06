import 'package:min_max_heap/min_max_heap.dart';
import 'package:test/test.dart';
import './data.dart' show Task;

void main() {
  group("Adding elements", () {
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
        for (; ascendingHeap.isNotEmpty;) ascendingHeap.removeMin,
      ];

      expect(oneToTen, newAscendingOrder);
    });

    test('Adding in descending order', () {
      final tenToOne = [for (var i = 9; i >= 0; i--) i];
      final descendingHeap = MinMaxHeap<int>.fromIterable(iterable: tenToOne);

      expect(descendingHeap.min, 0);
      expect(descendingHeap.max, 9);

      final newDescendingOrder = [
        for (; descendingHeap.isNotEmpty;) descendingHeap.removeMax,
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
        reason:
            'Drink water has more priority in this sample.'
            'Did you drink water today?',
      );
    });
  });
}
