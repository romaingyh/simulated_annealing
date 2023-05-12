import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simulated_annealing/models/city.dart';
import 'package:simulated_annealing/models/solution.dart';
import 'package:simulated_annealing/res/extensions.dart';

class SolutionPainter extends CustomPainter {
  final List<City> cities;
  final Iterable<DrawableSolution> solutions;

  const SolutionPainter({
    required this.cities,
    required this.solutions,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < solutions.length; i++) {
      final drawableSolution = solutions.elementAt(i);

      drawSolution(
        canvas: canvas,
        size: size,
        solution: drawableSolution.solution,
        color: drawableSolution.color,
        progress: drawableSolution.progress ?? 1.0,
        offset: i * 2.5,
      );
    }
  }

  void drawSolution({
    required Canvas canvas,
    required Size size,
    required Solution solution,
    required Color color,
    double offset = 0.0,
    double progress = 1.0,
  }) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color;

    final lines = <(Point<double> p1, Point<double> p2)>[];

    for (int i = 0; i < solution.citiesVisitOrder.length - 1; i++) {
      final city1 = cities[solution.citiesVisitOrder[i]];
      final city2 = cities[solution.citiesVisitOrder[i + 1]];

      lines.add((city1.location, city2.location));
    }

    final totalDistance = solution.evaluate(cities);
    var paintedDistance = 0.0;

    for (int i = 0; i < lines.length; i++) {
      final (p1, p2) = lines[i];
      final lineDistance = p1.distanceTo(p2);

      final lineStartProgress = paintedDistance / totalDistance;
      final lineEndProgress = (paintedDistance + lineDistance) / totalDistance;

      if (lineEndProgress <= progress) {
        paintedDistance += lineDistance;
        canvas.drawLine(
          p1.toOffsetScaled(size) + Offset(offset, offset),
          p2.toOffsetScaled(size) + Offset(offset, offset),
          paint,
        );
      } else {
        final lineProgress = (progress - lineStartProgress) / (lineEndProgress - lineStartProgress);
        paintedDistance += lineDistance * lineProgress;

        final startPoint = p1;
        final endPoint = p1 + (p2 - p1) * lineProgress;

        canvas.drawLine(
          startPoint.toOffsetScaled(size) + Offset(offset, offset),
          endPoint.toOffsetScaled(size) + Offset(offset, offset),
          paint,
        );
        break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is! SolutionPainter) {
      return true;
    }

    return oldDelegate.cities != cities || oldDelegate.solutions != solutions;
  }
}

class DrawableSolution {
  final Solution solution;
  final Color color;
  final double? progress;

  const DrawableSolution({
    required this.solution,
    required this.color,
    this.progress,
  });
}
