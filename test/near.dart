import 'package:test/test.dart';
import 'dart:math';

double near(double expected, double actual,
    {double eps = 1e-12, bool relative = false}) {
  var bound = relative ? eps * max(actual.abs(), expected.abs()) : eps;
  double epsMin = (actual - expected).abs() /
      (relative ? max(actual.abs(), expected.abs()) : 1.0);
  expect(actual, greaterThanOrEqualTo(expected - bound));
  expect(actual, lessThanOrEqualTo(expected + bound));
  return epsMin;
}
