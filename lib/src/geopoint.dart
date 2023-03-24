import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'package:vector_math/vector_math_64.dart';

import 'measure.dart';

class Geopoint {
  // http://wiki.gis.com/wiki/index.php/Geodetic_system
  // https://geographiclib.sourceforge.io/C++/doc/classGeographicLib_1_1Geodesic.html
  static const double semi_major_axis_in_meters = 6378137.0;
  static const double reciprocal_flattening = 1 / 298.257223563;
  static const double semi_minor_axis_in_meters =
      semi_major_axis_in_meters * (1 - reciprocal_flattening);
  static const double eccentricity2 =
      reciprocal_flattening * (2 - reciprocal_flattening);
  static const double mean_earth_radius_in_meters = 6371008.8;

  Angle latitude;
  Angle longitude;
  Distance elevation;

  Geopoint sphericalMidpoint(Geopoint p) {
    double dLon = p.longitude.radians - longitude.radians;

    double bx = p.latitude.cos * cos(dLon);
    double by = p.latitude.cos * sin(dLon);
    double phi = atan2(latitude.sin + p.latitude.sin,
        sqrt(pow(latitude.cos + bx, 2) + pow(by, 2)));
    double lambda = longitude.radians + atan2(by, latitude.cos + bx);
    double h = (elevation.meters + p.elevation.meters) / 2.0;
    return Geopoint(
        latitude: Angle.fromRadians(phi),
        longitude: Angle.fromRadians(lambda),
        elevation: Distance.fromMeters(h));
  }

  Vector3 toSphericalXYZ() {
    final double r = mean_earth_radius_in_meters + elevation.meters;
    final double x = r * latitude.cos * longitude.cos;
    final double y = r * latitude.cos * longitude.sin;
    final double z = r * latitude.sin;
    return Vector3(x, y, z);
  }

  Vector3 toSpheroidalXYZ() {
    final double chi = semi_major_axis_in_meters /
        sqrt(1.0 - eccentricity2 * pow(latitude.sin, 2));
    final double x = (chi + elevation.meters) * latitude.cos * longitude.cos;
    final double y = (chi + elevation.meters) * latitude.cos * longitude.sin;
    final double z =
        (chi * pow(1 - reciprocal_flattening, 2) + elevation.meters) *
            latitude.sin;
    return Vector3(x, y, z);
  }

  Vector3 toXYZ() => toSpheroidalXYZ();

  Geopoint.fromSphericalXYZ(Vector3 XYZ)
      : latitude = Angle.fromRadians(0),
        longitude = Angle.fromRadians(0),
        elevation = Distance.fromMeters(0) {
    final double x = XYZ[0];
    final double y = XYZ[1];
    final double z = XYZ[2];

    double r = sqrt(x * x + y * y + z * z);

    double h = r - mean_earth_radius_in_meters;
    double phi = asin(z / r);
    double lambda = atan2(y, x);

    latitude.radians = phi;
    longitude.radians = lambda;
    elevation.meters = h;
  }

  Geopoint.fromSpheroidalXYZ(Vector3 XYZ)
      : latitude = Angle.fromRadians(0),
        longitude = Angle.fromRadians(0),
        elevation = Distance.fromMeters(0) {
    const double a = semi_major_axis_in_meters;
    const double b = semi_minor_axis_in_meters;
    const double f = reciprocal_flattening;

    final double x = XYZ[0];
    final double y = XYZ[1];
    final double z = XYZ[2];

    const double e2 = eccentricity2;
    final double ep2 = e2 / pow(1 - f, 2);

    double r2 = (pow(x, 2) + pow(y, 2)).toDouble();
    double r = sqrt(r2);
    double E2 = (pow(a, 2) - pow(b, 2)).toDouble();
    double F = 54.0 * pow(b, 2) * pow(z, 2);
    double G = r2 + (1.0 - e2) * pow(z, 2) - e2 * E2;
    double c = (e2 * e2 * F * r2) / pow(G, 3);
    double s = pow(1.0 + c + sqrt(c * c + 2.0 * c), 1.0 / 3.0).toDouble();
    double P = F / (3.0 * pow(G * (s + 1.0 / s + 1.0), 2));
    double Q = sqrt(1.0 + 2.0 * e2 * e2 * P);
    double ro = -(e2 * P * r) / (1 + Q) +
        sqrt((a * a / 2) * (1 + 1 / Q) -
            ((1 - e2) * P * z * z) / (Q * (1 + Q)) -
            P * r2 / 2);
    double tmp = pow(r - e2 * ro, 2).toDouble();
    double U = sqrt(tmp + z * z);
    double V = sqrt(tmp + (1 - e2) * z * z);
    double zo = (b * b * z) / (a * V);

    double h = U * (1 - b * b / (a * V));
    double phi = atan((z + ep2 * zo) / r);
    double lambda = atan2(y, x);

    latitude.radians = phi;
    longitude.radians = lambda;
    elevation.meters = h;
  }

  Geopoint.fromXYZ(Vector3 XYZ) : this.fromSpheroidalXYZ(XYZ);

  double spheroidalDistanceInMeters(Geopoint p) {
    final a = toSpheroidalXYZ();
    final b = p.toSpheroidalXYZ();
    final double w = a.distanceTo(b);
    if (w > 1.95 * mean_earth_radius_in_meters) {
      Geopoint gc = sphericalMidpoint(p);
      return spheroidalDistanceInMeters(gc) + gc.spheroidalDistanceInMeters(p);
    }

    // c is the midpoint of the line segment (a,b)
    final c =
        Vector3((a[0] + b[0]) / 2.0, (a[1] + b[1]) / 2.0, (a[2] + b[2]) / 2.0);
    // find c in speroidal coordinates
    Geopoint gc = Geopoint.fromSpheroidalXYZ(c);
    // adjust the elevation to the middle of the two points.
    gc.elevation.meters = (elevation.meters + p.elevation.meters) / 2.0;

    final d = gc.toSpheroidalXYZ();

    double h = d.distanceTo(c);
    double el = arcSegmentLength(w, h);

    return el;
    // return el < mean_earth_radius_in_meters
    //     ? el
    //     : spheroidalDistanceInMeters(gc) + gc.spheroidalDistanceInMeters(p);
  }

  static double arcSegmentLength(double w, double h) {
    double x = ((h * w) / (pow(w / 2.0, 2) + pow(h, 2)).toDouble()).abs();

    double u;
    if (x < 1e-3) {
      u = (3.0 / 40.0) * pow(x, 6) + (1.0 / 6.0) * pow(x, 2) + 1.0;
    } else {
      u = (x < 1 ? asin(x) : pi / 2) / x;
    }
    return w * u;
  }

  Geopoint(
      {required this.latitude,
      required this.longitude,
      required this.elevation});

  double sphericalDistanceInMeters(Geopoint to) {
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
    double d = d0 *
        (Geopoint.mean_earth_radius_in_meters +
            (elevation.meters + to.elevation.meters) / 2.0) /
        (Geopoint.mean_earth_radius_in_meters);
    return sqrt(pow(d, 2) + pow(to.elevation.meters - elevation.meters, 2));
  }

  double distanceInMeters(Geopoint p) {
    return spheroidalDistanceInMeters(p);
  }
}
