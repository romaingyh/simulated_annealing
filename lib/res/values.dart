import 'dart:math';

import 'package:simulated_annealing/models/city.dart';
import 'package:simulated_annealing/models/exploration_startegy.dart';

const ExplorationStrategy kStrategy = ExplorationStrategy.randomly;
const double kCoolingRate = 0.99;
const double kInitialTemperature = 0.25;
const int kAnimationDuration = 1500;
const int kRandomSeed = 0;

final random = Random(kRandomSeed);

final List<City> cities = [
  City.randomPosition(name: 'Paris'),
  City.randomPosition(name: 'London'),
  City.randomPosition(name: 'Berlin'),
  City.randomPosition(name: 'Madrid'),
  City.randomPosition(name: 'Rome'),
  City.randomPosition(name: 'Lisbon'),
  City.randomPosition(name: 'Amsterdam'),
  City.randomPosition(name: 'Brussels'),
];
