import 'dart:math';
import 'package:vector_math/vector_math_64.dart';
import 'package:geopoint/src/measure.dart';
import 'package:geopoint/src/geoellipseoid.dart';
import 'package:geopoint/src/geosphere.dart';

const double _inverseGoldenRatio = 0.618033988749895; // (sqrt(5) - 1) / 2
const double _inverseGoldenRatio2 = 0.3819660112501051; // (3-sqrt(5)) / 2

double goldenSectionMinimize(
    double Function(double x) f, double a, double b, double tol) {
  if (b < a) {
    final tmp = a;
    a = b;
    b = tmp;
  }
  double h = b - a;
  if (h <= tol) {
    return (a + b) / 2.0;
  }

  int n = (log(tol / h) / log(_inverseGoldenRatio)).floor();

  double c = a + _inverseGoldenRatio2 * h;
  double d = a + _inverseGoldenRatio * h;
  double yc = f(c);
  double yd = f(d);

  for (int k = 0; k < n; ++k) {
    if (yc < yd) {
      b = d;
      d = c;
      yd = yc;
      h = _inverseGoldenRatio * h;
      c = a + _inverseGoldenRatio2 * h;
      yc = f(c);
    } else {
      a = c;
      c = d;
      yc = yd;
      h = _inverseGoldenRatio * h;
      d = a + _inverseGoldenRatio * h;
      yd = f(d);
    }
  }

  if (yc < yd) {
    return (a + d) / 2.0;
  } else {
    return (c + b) / 2.0;
  }
}

// use asin for theta <= pi/2
double arcSegmentLength(double chord, double height) {
  const double maxH = (1.4142135623730951 - 1) / 2.0; // (sqrt(2)-1)/2
  if (chord + height == chord) return chord;
  final h = (height / chord).abs();
  if (h <= maxH) {
    double x = h / (0.25 + pow(h, 2));
    double u = asin(x) / x;
    return chord * u;
  } else {
    double r = (0.25 + pow(h, 2)) / (2 * h);
    double theta = 2 * atan2(0.5, r - h);
    return chord * r * theta;
  }
}

abstract class Geopoint {
  Angle latitude;
  Angle longitude;
  Distance elevation;

  Geopoint(
      {required this.latitude,
      required this.longitude,
      required this.elevation});
  void setFromXYZ(Vector3 XYZ);
  Vector3 toXYZ();
  double distanceToInMeters(Geopoint to) {
    final a = toXYZ();
    final b = to.toXYZ();
    final chord = a.distanceTo(b);
    if (chord < Geosphere.mean_earth_radius_in_meters) {
      final c = Vector3(
          (a[0] + b[0]) / 2.0, (a[1] + b[1]) / 2.0, (a[2] + b[2]) / 2.0);
      final midpoint = clone();
      midpoint.setFromXYZ(c);
      midpoint.elevation.meters = (elevation.meters + to.elevation.meters) / 2;
      final double height = c.distanceTo(midpoint.toXYZ());
      return arcSegmentLength(chord, height);
    } else {
      final midpoint = clone();
      midpoint.implSetFromMidpoint(this, to);
      return distanceToInMeters(midpoint) + midpoint.distanceToInMeters(to);
    }
  }

  Distance distanceTo(Geopoint to) {
    return Distance.fromMeters(distanceToInMeters(to));
  }

  void implSetFromMidpoint(Geopoint p, Geopoint q);
  Geopoint clone();

  Geosphere sphere() =>
      Geosphere(latitude: latitude, longitude: longitude, elevation: elevation);
  Geoellipseoid ellipseoid() => Geoellipseoid(
      latitude: latitude, longitude: longitude, elevation: elevation);
}
