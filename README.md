<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

# MinMax heap in Dart

A binary heap, or priority queue, with quick access to min and max elements class.
> Dart 3.0.5 or higher required

## Dependencies

```dart
// This package uses internally the following:
import 'dart:math' show pow; // Inside min_max_heap.dart
import 'dart:math' show log; // Inside min_max_heap_base.dart
```

## Features

- [x] Dart 3.0 compatible
- [x] Supports generics and custom callback criteria
- [x] Generates the heap in a iterable or list form.
- [x] Insert, Remove (min and max), Get (min and max) operations
- [x] [index] operator for access supported!

## Getting started

### Concept

#### Binary heap (in general)
A binary heap is a data structure with 2 properties:

* Heap shape: The heap will have all levels, except the last one, fullfilled with max number of elements possible in this level. For example, see the image below:

![A binary min-heap representation, your array mode is: [1,2,3,17,19,36,7,25,100]](https://upload.wikimedia.org/wikipedia/commons/thumb/6/69/Min-heap.png/220px-Min-heap.png)
  * As you can see, the first's 3 levels have all number of nodes possible in the respective level (`pow(base: 2,exponent: level)`):
    * Level 0: 1 node
    * Level 1: 2 nodes
    * Level 2: 4 nodes
    * ...

* In a traditional min-heap, all nodes that have descendants should be less than all your respective descendants. The image above explains for yourself.

An interest thing about binary heaps in general is the fact they can be implemented in a List of values, not necessary linked nodes.
**This implementation uses 'list/array'.**

#### MinMax heap

If you try to find the maximum value in a min-heap, you will have O(lg n) in worst case. The same with find minimum value in a max-heap.
With MinMax heap, you have O(1) in the worst case to find both min and max value of all heap.
Operations like insert, remove (min and max) have O(lg n) in worst case. And the build method (when you pass a List<T> values in the input parameter) have O(n lg n) in worst case.
Here an image to illustrate a valid MinMax heap:

![MinMax heap, the array mode is [8,71,41,31,10,11,16,46,51,31,21,13]](https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/Min-max_heap.jpg/300px-Min-max_heap.jpg)

As you see, the min will always be the root, and the max will be or the direct left child or the direct right child of the root.

## Usage

You can build a heap from a List<T> values in input parameter.

```dart
void main() {
  final MinMaxHeap<int> myIntHeap = MinMaxHeap(input: [1,2,3,4,5,6,7,8]);
}
```

Or, you can build with successive insertions.

```dart
void main() {
  List<int> myInput = [1,2,3,4,5,6,7,8];
  final MinMaxHeap<int> myIntHeap = MinMaxHeap();
  for(final element in myInput) {
    myIntHeap.insert(element);
  }
}
```

Other aspect to consider is the use of the criteria parameter.
If you want to build your MinMax heap with custom criteria, you need to pass a callback funtion that returns `num` or `int` or `double` types.
Else will throw an Error.

```dart
void main() {
  List<String> myInput = ['hello', 'my', 'name', 'is', 'Elan', 'and', 'your', 'name', '?'];
  final MinMaxHeap<String> myStringHeap = MinMaxHeap(input: myInput, criteria: (word) => word.length);
}
```

You can use sucessive insertions with callbacks too.

```dart
void main() {
  List<String> myInput = ['hello', 'my', 'name', 'is', 'Elan', 'and', 'your', 'name', '?'];
  final MinMaxHeap<String> myStringHeap = MinMaxHeap(criteria: (word) => word.length);
  for(final element in myInput) {
    myStringHeap.insert(element);
  }
}
```

> **Curiosity**: If you use the same List of elements, but build one heap passing the input parameter and build other heap with the sme input, but with sucessive insertions, the results heaps can be different! But both are valid ones. Test and see!

## Additional information

This package can be improved and tips are welcome! You can create an issue in Github's repository.
