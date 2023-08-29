import 'package:logging/logging.dart';
import 'package:min_max_heap/min_max_heap.dart';

import 'data.dart';

typedef PriorityDeque<E extends Object> = MinMaxHeap<E>;

final log = Logger('Example');

void main(List<String> args) {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((event) {
    print('${event.level.name}: ${event.time.toLocal()}: ${event.message}');
  });

  final PriorityDeque<Task> taskManager = PriorityDeque.fromIterable(
    iterable: tasks,
    criteria: (Task task) => task.timeToBeDone.inMilliseconds,
  );

  log.info(taskManager.min);

  log.info(taskManager.max);

  taskManager.enqueueAll(const <Task>[
    Task(name: 'log', timeToBeDone: Duration(milliseconds: 50)),
    Task(name: 'heavy_operation', timeToBeDone: Duration(milliseconds: 1000)),
  ]);

  log.info(taskManager.min);

  log.info(taskManager.max);

  log.fine(taskManager.asMapOfLevels);
  //{
  //  0: [Task(name: log, timeToBeDone: 50)],
  //  1: [
  //        Task(name: heavy_operation, timeToBeDone: 1000),
  //        Task(name: sort_array, timeToBeDone: 300)
  //     ], 
  //  2: [
  //        Task(name: test_data, timeToBeDone: 250),
  //        Task(name: request_to_server, timeToBeDone: 500)
  //     ]
  // }

  log.info(taskManager.sortedView(isAscendingOrder: false));
}
