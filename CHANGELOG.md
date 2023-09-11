# Changelog

## 1.1.0

- Initial published version.

## 2.0.0

A great update is here! New getters and changes.

- Major changes:
  - Constructor now doesn't have the input parameter. To build a heap from an iterable, use the factory constructor fromIterable.
  - Prefer the new alias, like enqueue and dequeue.
  - `printTree` now is `logTree` and uses the `log.info` method instead `print`.
- Another changes
  - Removed the following properties, methods and getters:
    - `listMode`.
    - `operator []`.
  - New getters:
    - `isEmpty`.
    - `isNotEmpty`.
    - `_lastFather`.
    - `dequeueMin`.
    - `tryMin`.
    - `tryDequeueMin`.
    - `dequeueMax`.
    - `tryMax`.
    - `tryDequeueMax`.
    - `asMapOfLevels`.
  - New methods:
    - `sortedView`.
    - `enqueue`.
    - `enqueueAll`.
  - Changes:
    - New factory constructor to build the heap from iterable.
    - `iterable`.
    - `listMode` now is `asList`.
    - Now the `Criteria` enum doesn't used anymore. A bool approach is used instead.
    - Improving doc comments.

## 2.0.1

- Renaming methods, like `enqueue*` and `dequeue*` to `add*` and backing to `remove*`.
- New method `updateWhere`. This fix an issue at Github's repository.
- Fixed `sorted` method
- Some docs improvements.

## 2.0.2

- Better test coverage.
- New functions
  - `isValidMinMaxHeapListView`
  - `getSubtreeOf`
- New method `clear`, makes the heap empty.

## 2.0.3

- Fixing a hint to try achieve 140 pub points

## 2.1.0

These update changes the signature of `updateWhere` method and release a `replaceWhere` method.

- The `updateWhere` method now is `replaceWhere`.
  - `replaceWhere`, as the name says, replace every element which predicate is satisfied.
- A new funtion `updateWhere`.
  - This function have change the signature. Now you should pass a void function.

For more details, see `min_max_heap_test.dart` file.
