import 'dart:math';

import 'package:vector_math/vector_math_64.dart';
import 'package:geopoint/src/measure.dart';
import 'package:geopoint/src/geoellipseoid.dart';
import 'package:geopoint/src/geosphere.dart';

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
  double distanceToInMeters(Geopoint to);
  Distance distanceTo(Geopoint to) {
    return Distance.fromMeters(distanceToInMeters(to));
  }

  void setFromMidpoint(Geopoint p, Geopoint q);

  Geopoint clone();
  Geosphere sphere() =>
      Geosphere(latitude: latitude, longitude: longitude, elevation: elevation);
  Geoellipseoid ellipseoid() => Geoellipseoid(
      latitude: latitude, longitude: longitude, elevation: elevation);
}
