import 'dart:math';

import 'package:geopoint/src/geoellipseoid.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:geopoint/src/measure.dart';
import 'package:geopoint/src/geopoint.dart';

class Geosphere extends Geopoint {
  static const double mean_earth_radius_in_meters = 6371008.8;
  @override
  void setFromMidpoint(Geopoint p, Geopoint q) {
    double dlambda = q.longitude.radians - p.longitude.radians;
    double b = q.latitude.cos;
    double bx = b * cos(dlambda);
    double by = b * sin(dlambda);
    double dx = p.latitude.cos + bx;

    latitude.atan2(
        p.latitude.sin + q.latitude.sin, sqrt(pow(dx, 2) + pow(by, 2)));
    longitude.radians = p.longitude.radians + atan2(by, dx);
    elevation.meters = (p.elevation.meters + q.elevation.meters) / 2.0;
  }

  @override
  void setFromXYZ(Vector3 XYZ) {
    final double x = XYZ[0];
    final double y = XYZ[1];
    final double z = XYZ[2];

    double r = sqrt(x * x + y * y + z * z);

    latitude.sin = z / r;
    longitude.atan2(y, x);
    elevation.meters = r - mean_earth_radius_in_meters;
  }

  Geosphere(
      {required super.latitude,
      required super.longitude,
      required super.elevation});

  Geosphere.fromXYZ(Vector3 XYZ)
      : super(
            latitude: Angle.fromRadians(0),
            longitude: Angle.fromRadians(0),
            elevation: Distance.fromMeters(0)) {
    setFromXYZ(XYZ);
  }

  Geosphere.fromMidpoint(Geopoint p, Geopoint q)
      : super(
            latitude: Angle.fromRadians(0),
            longitude: Angle.fromRadians(0),
            elevation: Distance.fromMeters(0)) {
    setFromMidpoint(p, q);
  }

  @override
  Vector3 toXYZ() {
    final double R = mean_earth_radius_in_meters + elevation.meters;
    final double r = R * latitude.cos;
    final double x = r * longitude.cos;
    final double y = r * longitude.sin;
    final double z = R * latitude.sin;
    return Vector3(x, y, z);
  }

  @override
  Geosphere sphere() => this;

  @override
  Geosphere clone() => Geosphere(
      latitude: Angle.fromRadians(latitude.radians),
      longitude: Angle.fromRadians(longitude.radians),
      elevation: Distance.fromMeters(elevation.meters));
}
