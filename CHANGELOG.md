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
    - 
  - Changes:
    - New factory constructor to build the heap from iterable.
    - `iterable`.
    - `listMode` now is `asList`.
    - Now the `Criteria` enum doesn't used anymore. A bool approach is used instead.
    - Improving doc comments.