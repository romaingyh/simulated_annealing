import 'package:flutter/material.dart';
import 'package:simulated_annealing/models/city.dart';

class CitiesPainter extends CustomPainter {
  final List<City> cities;
  final ThemeData theme;

  const CitiesPainter({
    required this.cities,
    required this.theme,
  });

  Color get cityColor => theme.colorScheme.primary;

  TextStyle? get cityNameStyle => theme.textTheme.titleMedium;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = cityColor;

    for (final city in cities) {
      final position = Offset(city.location.x * size.width, city.location.y * size.height);

      canvas.drawCircle(position, 10, paint);

      final textPainter = _getTextPainter(city.name, cityNameStyle);
      final textPosition = Offset(
        position.dx - textPainter.width / 2,
        position.dy + textPainter.height / 2,
      );
      textPainter.paint(canvas, textPosition);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is CitiesPainter && oldDelegate.cities != cities;
  }

  TextPainter _getTextPainter(String text, [TextStyle? style]) {
    return TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
  }
}
