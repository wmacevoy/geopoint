import 'dart:math';

import 'package:vector_math/vector_math_64.dart';
import 'package:geopoint/src/measure.dart';
import 'package:geopoint/src/geopoint.dart';
import 'package:geopoint/src/geosphere.dart';

class Geoellipseoid extends Geopoint {
  // http://wiki.gis.com/wiki/index.php/Geodetic_system
  // https://geographiclib.sourceforge.io/C++/doc/classGeographicLib_1_1Geodesic.html
  static const double semi_major_axis_in_meters = 6378137.0;
  static const double reciprocal_flattening = 1 / 298.257223563;
  static const double semi_minor_axis_in_meters =
      semi_major_axis_in_meters * (1 - reciprocal_flattening);
  static const double eccentricity2 =
      reciprocal_flattening * (2 - reciprocal_flattening);

  @override
  Vector3 toXYZ() {
    double phi = latitude.radians;
    double lambda = longitude.radians;
    double h = elevation.meters;

    final double R =
        semi_major_axis_in_meters / sqrt(1 - eccentricity2 * pow(sin(phi), 2));
    final double r = (R + h) * cos(phi);
    final double x = r * cos(lambda);
    final double y = r * sin(lambda);
    final double z =
        (R * pow(1 - reciprocal_flattening, 2) + elevation.meters) * sin(phi);
    return Vector3(x, y, z);
  }

  @override
  void setFromXYZ(Vector3 XYZ) {
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

  @override
  void setFromMidpoint(Geopoint gp, Geopoint gq) {
    final p = gp.ellipseoid();
    final q = gq.ellipseoid();
    final a = p.toXYZ();
    final b = q.toXYZ();
    final c =
        Vector3((a[0] + b[0]) / 2.0, (a[1] + b[1]) / 2.0, (a[2] + b[2]) / 2.0);
    final cLen = c.length;
    if (cLen > 2 * (semi_major_axis_in_meters - semi_minor_axis_in_meters)) {
      c.scale(Geosphere.mean_earth_radius_in_meters / cLen);
      setFromXYZ(c);
      elevation.meters = (p.elevation.meters + q.elevation.meters) / 2.0;
    } else {
      Geoellipseoid flatten(Geopoint p) {
        return p.elevation.meters == 0
            ? p.ellipseoid()
            : Geoellipseoid(
                latitude: latitude,
                longitude: longitude,
                elevation: Distance.fromMeters(0));
      }

      final p0 = flatten(p);
      final q0 = flatten(q);
      final sn = (p0.toXYZ() - q0.toXYZ()).normalized();
      final m0 = Geosphere.fromMidpoint(p0, q0).toXYZ();

      int paths = 360;
      final dists = <double>[];

      Geoellipseoid M(double theta) {
        final m = m0.clone();
        m.applyAxisAngle(sn, theta);
        final em = Geoellipseoid.fromXYZ(m);
        em.elevation.meters = 0;
        return em;
      }

      double D(double theta) {
        final em = M(theta);
        return p0.distanceToInMeters(em) + em.distanceToInMeters(q0);
      }

      for (var path = 0; path < paths; ++path) {
        final m = m0.clone();
        double theta = (2 * pi * path) / paths;
        dists.add(D(theta));
      }

      double minDist = 4 * Geosphere.mean_earth_radius_in_meters;
      double minTheta = 0;
      Geoellipseoid? minM;

      for (var path = 0; path < paths; ++path) {
        if (dists[path] < dists[(path + 1) % paths] &&
            dists[path] < dists[(path + paths - 1) % paths]) {
          double theta0 = (2 * pi * (path - 1)) / paths;
          double theta1 = (2 * pi * (path - 1)) / paths;
          double theta = goldenSectionMinimize(D, theta0, theta1, 1e-4);
          final m = M(theta);
          double d = p0.distanceToInMeters(m) + m.distanceToInMeters(q0);
          if (d < minDist) {
            minDist = d;
            minTheta = theta;
            minM = m;
          }
        }
      }
      if (minM == null) {
        throw StateError("no minimum found");
      }
      latitude.radians = minM.latitude.radians;
      longitude.radians = minM.longitude.radians;
      elevation.meters = (p.elevation.meters + q.elevation.meters) / 2;
    }
  }

  Geoellipseoid(
      {required super.latitude,
      required super.longitude,
      required super.elevation});

  Geoellipseoid.fromXYZ(Vector3 XYZ)
      : super(
            latitude: Angle.fromRadians(0),
            longitude: Angle.fromRadians(0),
            elevation: Distance.fromMeters(0)) {
    setFromXYZ(XYZ);
  }

  Geoellipseoid.fromMidpoint(Geopoint p, Geopoint q)
      : super(
            latitude: Angle.fromRadians(0),
            longitude: Angle.fromRadians(0),
            elevation: Distance.fromMeters(0)) {
    setFromMidpoint(p, q);
  }

  @override
  Geoellipseoid ellipseoid() => this;

  @override
  Geoellipseoid clone() => Geoellipseoid(
      latitude: Angle.fromRadians(latitude.radians),
      longitude: Angle.fromRadians(longitude.radians),
      elevation: Distance.fromMeters(elevation.meters));
}
