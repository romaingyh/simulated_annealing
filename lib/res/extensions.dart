import 'dart:math';

import 'package:flutter/material.dart';

extension PointX on Point<num> {
  Offset get toOffset => Offset(x as double, y as double);
  Offset toOffsetScaled(Size size) => Offset(x * size.width, y * size.height);
}
