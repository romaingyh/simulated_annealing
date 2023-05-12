part of 'simulation_cubit.dart';

@immutable
sealed class SimulationState {
  final int generation;
  final Solution currentSolution;
  final Solution? nextSolution;
  final double temperature;
  final ExplorationStrategy strategy;

  const SimulationState({
    this.generation = 0,
    required this.currentSolution,
    this.nextSolution,
    required this.temperature,
    this.strategy = ExplorationStrategy.randomly,
  });
}

class SimulationStateInitial extends SimulationState {
  SimulationStateInitial({
    required List<City> cities,
    required double temperature,
  }) : super(
          currentSolution: Solution.random(
            random: random,
            citiesCount: cities.length,
          ),
          temperature: temperature,
        );
}

class SimulationStateRunning extends SimulationState {
  const SimulationStateRunning({
    required int generation,
    required Solution currentSolution,
    required Solution nextSolution,
    required double temperature,
    required ExplorationStrategy strategy,
  }) : super(
          generation: generation,
          currentSolution: currentSolution,
          nextSolution: nextSolution,
          temperature: temperature,
          strategy: strategy,
        );

  SimulationStateRunning next({
    required Solution currentSolution,
    required Solution nextSolution,
    required double temperature,
  }) {
    return SimulationStateRunning(
      generation: generation + 1,
      currentSolution: currentSolution,
      nextSolution: nextSolution,
      temperature: temperature,
      strategy: strategy,
    );
  }
}
