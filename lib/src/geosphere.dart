import 'dart:math';

import 'package:geopoint/src/geoellipseoid.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:geopoint/src/measure.dart';
import 'package:geopoint/src/geopoint.dart';
import 'package:geopoint/src/geoellipseoid.dart';

class Geosphere extends Geopoint {
  static const double mean_earth_radius_in_meters = 6371008.8;
  @override
  void setFromMidpoint(Geopoint p, Geopoint q) {
    double dLon = q.longitude.radians - p.longitude.radians;

    double bx = q.latitude.cos * cos(dLon);
    double by = q.latitude.cos * sin(dLon);

    latitude.radians = atan2(p.latitude.sin + q.latitude.sin,
        sqrt(pow(p.latitude.cos + bx, 2) + pow(by, 2)));
    longitude.radians = p.longitude.radians + atan2(by, p.latitude.cos + bx);
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

  Geosphere.fromMidpoint(Geosphere p, Geosphere q)
      : super(
            latitude: Angle.fromRadians(0),
            longitude: Angle.fromRadians(0),
            elevation: Distance.fromMeters(0)) {
    setFromMidpoint(this, p, q);
  }

  @override
  Vector3 toXYZ() {
    final double r = mean_earth_radius_in_meters + elevation.meters;
    final double x = r * latitude.cos * longitude.cos;
    final double y = r * latitude.cos * longitude.sin;
    final double z = r * latitude.sin;
    return Vector3(x, y, z);
  }

  @override
  double distanceToInMeters(Geopoint to) {
    double phi1 = latitude.radians;
    double phi2 = to.latitude.radians;

    double lambda1 = longitude.radians;
    double lambda2 = to.longitude.radians;

    double dz = sin(phi2) - sin(phi1);
    double dx = cos(phi2) * cos(lambda2) - cos(phi1) * cos(lambda1);
    double dy = cos(phi2) * sin(lambda2) - cos(phi1) * sin(lambda1);
    double c = sqrt(dx * dx + dy * dy + dz * dz);

    double dsigma = asin(c / 2.0);

    double d0 = 2.0 * mean_earth_radius_in_meters * dsigma;
    double hbar = (elevation.meters + to.elevation.meters) / 2.0;
    double dh = (to.elevation.meters - elevation.meters);

    double d =
        d0 * (mean_earth_radius_in_meters + hbar) / mean_earth_radius_in_meters;

    return d * sqrt(1 + pow(dh / d, 2));
  }

  @override
  Geosphere clone() =>
      Geosphere(latitude: latitude, longitude: longitude, elevation: elevation);
  @override
  Geosphere sphere() => this;
  @override
  Geoellipseoid ellipseoid() =>
      Geoellipseoid(latitude: latitude, longitude: longitude, elevation: elevation)
}
