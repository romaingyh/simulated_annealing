import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:simulated_annealing/models/city.dart';
import 'package:simulated_annealing/models/exploration_startegy.dart';
import 'package:simulated_annealing/models/solution.dart';
import 'package:simulated_annealing/res/values.dart';

part 'simulation_state.dart';

class SimulationCubit extends Cubit<SimulationState> {
  SimulationCubit()
      : super(
          SimulationStateInitial(cities: cities, temperature: kInitialTemperature),
        );

  void generateNext() {
    final currentSolution = state.currentSolution;

    switch (state) {
      case SimulationStateInitial():
        final nextSolution = currentSolution.mutate(strategy: state.strategy).$1;

        emit(
          SimulationStateRunning(
            generation: 0,
            currentSolution: currentSolution,
            nextSolution: nextSolution,
            temperature: state.temperature,
            strategy: state.strategy,
          ),
        );

      case SimulationStateRunning():
        final nextSolution = state.nextSolution!;
        final score = nextSolution.evaluate(cities);
        final delta = score - currentSolution.evaluate(cities);

        final probability = exp(-delta / state.temperature);
        final accepted = delta < 0 || random.nextDouble() < probability;

        final updatedSolution = accepted ? nextSolution : currentSolution;

        emit(
          (state as SimulationStateRunning).next(
            currentSolution: updatedSolution,
            nextSolution: updatedSolution.mutate(strategy: state.strategy).$1,
            temperature: state.temperature * kCoolingRate,
          ),
        );
    }
  }
}
