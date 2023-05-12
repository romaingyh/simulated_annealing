import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:simulated_annealing/cubit/simulation_cubit.dart';
import 'package:simulated_annealing/res/values.dart';
import 'package:simulated_annealing/view/widgets/cities_painter.dart';
import 'package:simulated_annealing/view/widgets/scores_chart.dart';
import 'package:simulated_annealing/view/widgets/simulation_infos.dart';
import 'package:simulated_annealing/view/widgets/solution_painter.dart';

void main() {
  runApp(
    BlocProvider(
      create: (BuildContext context) {
        return SimulationCubit();
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simulated Annealing',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Simulated Annealing'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  final List<double> _scores = [];

  late AnimationController _animationController;
  double _animationProgress = 0.0;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: kAnimationDuration),
    );

    _animationController.addListener(
      () => setState(
        () => _animationProgress = _animationController.value,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        final cubit = context.read<SimulationCubit>();

        setState(() {
          _scores.add(cubit.state.currentSolution.evaluate(cities));
          if (_scores.length > 100) {
            _scores.removeAt(0);
          }
        });

        context.read<SimulationCubit>().generateNext();
        _animationController.reset();
        _animationController.forward();
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      context.read<SimulationCubit>().generateNext();
      _animationController.reset();
      _animationController.forward();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final state = context.watch<SimulationCubit>().state;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Table(
              columnWidths: const {
                1: FlexColumnWidth(),
                2: FlexColumnWidth(),
              },
              children: [
                TableRow(
                  children: [
                    SimulationInfos(animationProgress: _animationProgress),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.fill,
                      child: ScoresChart(scores: _scores),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomPaint(
              foregroundPainter: CitiesPainter(cities: cities, theme: theme),
              painter: SolutionPainter(
                cities: cities,
                solutions: [
                  DrawableSolution(
                    solution: state.currentSolution,
                    color: theme.colorScheme.primary,
                  ),
                  if (state.nextSolution != null)
                    DrawableSolution(
                      solution: state.nextSolution!,
                      color: theme.colorScheme.tertiary,
                      progress: _animationProgress,
                    ),
                ],
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}
