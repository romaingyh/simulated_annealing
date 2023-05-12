// A class representing a solution to the commercial traveller problem.
import 'dart:math';

import 'package:simulated_annealing/models/city.dart';
import 'package:simulated_annealing/models/exploration_startegy.dart';

class Solution {
  final List<int> citiesVisitOrder;

  const Solution({
    required this.citiesVisitOrder,
  });

  factory Solution.random({
    required Random random,
    required int citiesCount,
  }) {
    final citiesVisitOrder = List.generate(citiesCount, (i) => i)..shuffle(random);

    return Solution(citiesVisitOrder: citiesVisitOrder);
  }

  (Solution solution, int swapIndexA, int swapIndex) mutate({
    required ExplorationStrategy strategy,
  }) {
    final source = List.of(citiesVisitOrder);

    final (indexA, indexB) = strategy.getSwapIndexes(maxIndex: source.length);

    final cityA = source[indexA];
    final cityB = source[indexB];

    source[indexA] = cityB;
    source[indexB] = cityA;

    return (Solution(citiesVisitOrder: source), indexA, indexB);
  }

  double evaluate(List<City> cities) {
    double distance = 0.0;

    for (int i = 0; i < citiesVisitOrder.length - 1; i++) {
      final indexA = citiesVisitOrder.elementAt(i);
      final indexB = citiesVisitOrder.elementAt(i + 1);
      final cityA = cities[indexA];
      final cityB = cities[indexB];

      distance += cityA.location.distanceTo(cityB.location);
    }

    return distance;
  }
}
