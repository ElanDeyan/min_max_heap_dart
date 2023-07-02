import 'package:min_max_heap/min_max_heap.dart';

final class User {
  final String name;
  final int age;
  User({required this.name, required this.age});
}

void main(List<String> args) {
  final MinMaxHeap<User> myHeap = MinMaxHeap(
    input: [for (int i = 0; i < 5; i++) User(name: 'Name$i', age: i)],
    criteria: (user) => user.age,
  );
  print(myHeap.toList.map((e) => e.age));
}
