import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ScoresChart extends StatelessWidget {
  final List<double> scores;

  const ScoresChart({
    super.key,
    required this.scores,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LineChart(
      swapAnimationDuration: Duration.zero,
      LineChartData(
        borderData: FlBorderData(
          border: Border.all(color: theme.colorScheme.primaryContainer),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return [
                for (final spot in touchedSpots)
                  LineTooltipItem(
                    spot.y.toStringAsFixed(2),
                    TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
              ];
            },
          ),
        ),
        gridData: FlGridData(
          getDrawingHorizontalLine: (value) => FlLine(
            color: theme.colorScheme.primaryContainer,
            strokeWidth: 0.4,
            dashArray: [8, 4],
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: theme.colorScheme.primaryContainer,
            strokeWidth: 0.4,
            dashArray: [8, 4],
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(),
          topTitles: AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 44,
              getTitlesWidget: (value, meta) => Text(value.toStringAsFixed(2)),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Text(value.toStringAsFixed(0)),
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (final (index, score) in scores.indexed) FlSpot(index.toDouble(), score),
            ],
            color: theme.colorScheme.primary,
            barWidth: 2,
            dotData: FlDotData(
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                color: theme.colorScheme.primary,
                radius: 2,
              ),
            ),
          ),
        ],
        //minY: 0,
        minX: 0,
        maxX: 100,
      ),
    );
  }
}
