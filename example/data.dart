final class Task {
  final Duration timeToBeDone;
  String name;
  Task({required this.name, required this.timeToBeDone});

  @override
  String toString() =>
      'Task(name: $name, timeToBeDone: ${timeToBeDone.inMilliseconds})';
}

final tasks = <Task>[
  Task(
    name: 'test_data',
    timeToBeDone: const Duration(milliseconds: 250),
  ),
  Task(
    name: 'request_to_server',
    timeToBeDone: const Duration(milliseconds: 500),
  ),
  Task(
    name: 'sort_array',
    timeToBeDone: const Duration(milliseconds: 300),
  ),
];

final class Client {
  final String name;
  final int age;
  const Client({required this.name, required this.age});
}

const clients = <Client>[
  Client(name: 'Kyle', age: 29),
  Client(name: 'Rick', age: 21),
  Client(name: 'Troy', age: 50),
];
