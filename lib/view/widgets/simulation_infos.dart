import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:simulated_annealing/cubit/simulation_cubit.dart';
import 'package:simulated_annealing/res/values.dart';

class SimulationInfos extends StatelessWidget {
  final double animationProgress;

  const SimulationInfos({
    super.key,
    required this.animationProgress,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SimulationCubit>().state;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Generation ${state.generation}',
            ),
            Text(
              state.currentSolution.citiesVisitOrder
                  .map((e) => cities[e].name.substring(0, 3))
                  .join(' -> '),
            ),
            Text(
              'Score ${state.currentSolution.evaluate(cities).toStringAsFixed(2)}',
            ),
            const SizedBox(height: 16),
            if (state.nextSolution != null) ...[
              const Text('Current try'),
              Text(
                state.nextSolution!.citiesVisitOrder
                    .map((e) => cities[e].name.substring(0, 3))
                    .join(' -> '),
              ),
              Text(
                'Score ${(state.nextSolution!.evaluate(cities) * animationProgress).toStringAsFixed(2)}',
              ),
            ],
          ],
        ),
        const SizedBox(width: 16),
        Text(
          'Temperature: ${state.temperature.toStringAsFixed(4)}',
        ),
      ],
    );
  }
}
