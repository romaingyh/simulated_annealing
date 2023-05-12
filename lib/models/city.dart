import 'dart:math';

import 'package:simulated_annealing/res/values.dart';

class City {
  final String name;
  final Point<double> location;

  const City({required this.name, required this.location});

  /// Returns a random city with a random location.
  /// Location coordinates are between 0 and 1.
  factory City.randomPosition({required String name}) {
    final x = random.nextDouble();
    final y = random.nextDouble();

    return City(name: name, location: Point(x, y));
  }

  @override
  String toString() {
    return 'City(name: $name, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is City && other.name == name && other.location == location;
  }

  @override
  int get hashCode => name.hashCode ^ location.hashCode;
}
