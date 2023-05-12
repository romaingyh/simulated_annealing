// Define the strategy to permute cities visit index in the simulated annealing algorithm.
import '../res/values.dart';

enum ExplorationStrategy {
  // Randomly swap two cities visit index.
  randomly,

  // Swap two cities visit index in a circular way.
  circular;

  (int indexA, int indexB) getSwapIndexes({required int maxIndex}) {
    switch (this) {
      case ExplorationStrategy.randomly:
        var indexA = random.nextInt(maxIndex);
        var indexB = random.nextInt(maxIndex);

        while (indexB == indexA) {
          indexB = random.nextInt(maxIndex);
        }

        return (indexA, indexB);

      case ExplorationStrategy.circular:
        final indexA = random.nextInt(maxIndex);
        final indexB = (indexA + 1) % maxIndex;

        return (indexA, indexB);
    }
  }
}
