import 'package:min_max_heap/min_max_heap.dart';
import 'package:test/test.dart';

final class Person {
  final String name;
  final int age;
  const Person(this.name, this.age);
}

void main() {
  group('Build from list', () {
    final MinMaxHeap<String> myStringHeap = MinMaxHeap(
      input: ['oi', 'tudo', 'bem', '?'],
      criteria: (element) => element.length,
    );

    test(
      'Build',
      () => expect(myStringHeap.listMode, ['?', 'tudo', 'bem', 'oi']),
    );
  });
  group('Insertion tests', () {
    test('Basic test', () {
      final testCases = [1, 4, -5, 6, 7, 9, 3, 40, 20, 2, 70, 100];
      const expectResult = [-5, 70, 100, 4, 2, 1, 3, 7, 20, 6, 40, 9];
      final MinMaxHeap<int> myFirstIntHeap = MinMaxHeap();
      for (final testCase in testCases) {
        myFirstIntHeap.insert(testCase);
      }
      expect(myFirstIntHeap.listMode, expectResult);
    });
  });

  group('Remove tests', () {
    final MinMaxHeap<double> myDoubleHeap = MinMaxHeap(
      input: [1, 4.7, 3.9, 25.899, -5, 2, 6], // the min element should be -5
    );
    test('Remove min', () => expect(myDoubleHeap.removeMin(), -5));

    test('Remove max', () => expect(myDoubleHeap.removeMax(), 25.899));
  });

  group('Find tests', () {
    final List<Person> myUsers = [
      for (int i = 0; i < 10; i++) Person('Person$i', i)
    ];

    final MinMaxHeap<Person> myUsersHeap = MinMaxHeap(
      input: myUsers,
      criteria: (person) => person.age,
    );

    test('Find min (getter)', () => expect(myUsersHeap.min, myUsers.first));

    test('Find max (getter)', () => expect(myUsersHeap.max, myUsers.last));
  });

  group('Funny case', () {
    print(
      'What if you pass the same input array, but use different processes to build?',
    );
    final List<int> input = [1, 4, -5, 6, 7, 9, 3, 40, 20, 2, 70, 100];
    final MinMaxHeap<int> build = MinMaxHeap(
      input: input,
    );
    final MinMaxHeap<int> sucessiveInsertion = MinMaxHeap();
    for (final element in input) {
      sucessiveInsertion.insert(element);
    }
    print('Heap with build process');
    build.printTree();

    print('Heap with sucessive insertions');
    sucessiveInsertion.printTree();

    test('Are they equals?', () {
      expect(build.listMode != sucessiveInsertion.listMode, true);
    });

    print('Differents, but valid ones!');

    print('Draw the tree and see!');
  });
}
