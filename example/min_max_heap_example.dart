import 'package:min_max_heap/min_max_heap.dart';

final class User {
  final String name;
  final int age;
  User({required this.name, required this.age});
}

void main(List<String> args) {
  /// You can use `num` data types to build your heap without criteria callback.
  final MinMaxHeap<int> myIntHeap =
      MinMaxHeap(input: [3, 4, 5, 6, 1, 2, 8, 9, 10]);
  print('Int heap without criteria callback');
  print('Removing the max: ${myIntHeap.removeMax()}'); // 10;
  print('Removing the max: ${myIntHeap.removeMax()}'); // 9;
  print('Removing the min: ${myIntHeap.removeMin()}'); // 1;
  print('Removing the min: ${myIntHeap.removeMin()}'); // 2;
  print('After the operations above, the new min is ${myIntHeap.min}'); // 3;
  print('After the operations above, the new max is ${myIntHeap.max}'); // 8;
  myIntHeap.insert(-1); // The new root of heap, will be the minimum one.
  print('The actual min is ${myIntHeap.min}'); // What you think? -1 or 3?
  print('The heap in List mode: ${myIntHeap.listMode}');

  /// You can use `num` data types with `criteria` callback
  final MinMaxHeap<double> myDoubleHeap = MinMaxHeap(
    input: [1.3, 4.7, 3.8, 19.4, 29.34, -5.3, 14],
    criteria: (element) => element / 2,
  );
  print('Double heap with criteria callback');
  print('Removing the max: ${myDoubleHeap.removeMax()}'); // 29.34;
  print('Removing the max: ${myDoubleHeap.removeMax()}'); // 19.4;
  print('Removing the min: ${myDoubleHeap.removeMin()}'); // -5.3;
  print('Removing the min: ${myDoubleHeap.removeMin()}'); // 1.3;
  print(
      'After the operations above, the new min is ${myDoubleHeap.min}'); // 3.8;
  print(
      'After the operations above, the new max is ${myDoubleHeap.max}'); // 14;
  myDoubleHeap.insert(
      50.7); // The new direct child of the root, will be the maximum one.
  print('The actual max is ${myDoubleHeap.max}'); // What you think? 50.7 or 14?
  print('The heap in List mode: ${myDoubleHeap.listMode}');

  /// You can use pritive non numbers data types, only with `criteria` callback.
  /// Only the first one will throw an Error.
  /// Uncomment and remove the exclamation mark to see.
  //! final MinMaxHeap<String> myStringHeap1 =
  //!     MinMaxHeap(input: ['hello', 'my', 'name', 'is', 'Elan']);
  final MinMaxHeap<String> myStringHeap2 = MinMaxHeap(
    input: ['hello', 'my', 'name', 'is', 'Elan', 'and', 'your', 'name', '?'],
    criteria: (element) => element.length,
  );
  print('String heap with criteria callback');
  print('Removing the max: ${myStringHeap2.removeMax()}'); // 'hello';
  print(
      'Removing the max: ${myStringHeap2.removeMax()}'); // one of ['name', 'Elan', 'your', 'name'];
  print('Removing the min: ${myStringHeap2.removeMin()}'); // '?';
  print(
      'Removing the min: ${myStringHeap2.removeMin()}'); // one of ['my', 'is'];
  print(
      'After the operations above, the new min is ${myStringHeap2.min}'); // the rest one of ['my', 'is'];
  print(
      'After the operations above, the new max is ${myStringHeap2.max}'); // one of ['name', 'Elan', 'your', 'name'] rest ones;
  myStringHeap2.insert(
      'Thanks!'); // The new direct child of the root, will be the maximum one.
  print(
      'The actual max is ${myStringHeap2.max}'); // What you think? 'Thanks!' or one of ['name', 'Elan', 'your', 'name'] rest ones?
  print('The heap in List mode: ${myStringHeap2.listMode}');

  /// Or with custom classes but, again, with `criteria` callback.
  final MinMaxHeap<User> myUsersHeap = MinMaxHeap(
    input: [for (int i = 0; i < 5; i++) User(name: 'Name$i', age: i)],
    criteria: (user) => user.age,
  );
  print('Users heap with age criteria callback');
  print('Removing the max: ${myUsersHeap.removeMax().name}'); // Name4;
  print('Removing the max: ${myUsersHeap.removeMax().name}'); // Name3;
  print('Removing the min: ${myUsersHeap.removeMin().name}'); // Name0;
  print('Removing the min: ${myUsersHeap.removeMin().name}'); // Name1;
  print(
      'After the operations above, the new min is ${myUsersHeap.min.name}'); // Name2;
  print(
      'After the operations above, the new max is ${myUsersHeap.max.name}'); // Name2;
  myUsersHeap.insert(User(
      name: 'Name6',
      age: 6)); // The new direct child of the root, will be the maximum one.
  print(
      'The actual max is ${myUsersHeap.max.name}'); // What you think? Name6 or Name2?
  print('The heap in List mode: ${myUsersHeap.iterable.map(
        (e) => e.name,
      ).toList()}');
}
