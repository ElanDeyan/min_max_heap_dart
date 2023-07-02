import 'package:min_max_heap/min_max_heap.dart';
import 'package:test/test.dart';

void main() {
  group('Insertion tests', () {
    test('Basic test', () {
      final testCases = [10, 7, 12, 5, 9, 15, 3];
      const expectResult = [3, 15, 9, 7, 10, 12, 5];
      final MinMaxHeap<int> myFirstIntHeap = MinMaxHeap();
      for (final testCase in testCases) {
        myFirstIntHeap.insert(testCase);
      }
      myFirstIntHeap.printTree();
      expect(myFirstIntHeap.toList, expectResult);
    });
  });
}
