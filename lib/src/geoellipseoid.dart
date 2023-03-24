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

    final double chi =
        semi_major_axis_in_meters / sqrt(1 - eccentricity2 * pow(sin(phi), 2));
    final double r = (chi + h) * cos(phi);
    final double x = r * cos(lambda);
    final double y = r * sin(lambda);
    final double z =
        (chi * pow(1 - reciprocal_flattening, 2) + elevation.meters) * sin(phi);
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
  void setFromMidpoint(Geopoint p, Geopoint q) {
    final a = p.ellipseoid().toXYZ();
    final b = q.ellipseoid().toXYZ();
    final double w = a.distanceTo(b);
    if (w < 1.95 * semi_major_axis_in_meters) {
      final c = Vector3(
          (a[0] + b[0]) / 2.0, (a[1] + b[1]) / 2.0, (a[2] + b[2]) / 2.0);
      c.scale(Geosphere.mean_earth_radius_in_meters / c.length);
      setFromXYZ(c);
      elevation.meters = (elevation.meters + p.elevation.meters) / 2.0;
    } else {
      sphere().setFromMidpoint(p.sphere(), q.sphere());
    }
  }

  @override
  double distanceToInMeters(Geopoint to) {
    final eTo = to.ellipseoid();
    final a = toXYZ();
    final b = eTo.toXYZ();
    final double w = a.distanceTo(b);
    final m = Geoellipseoid.fromMidpoint(this, eTo);
    if (w > 1.95 * semi_major_axis_in_meters) {
      Geosphere sphereFrom = Geosphere(
          latitude: latitude, longitude: longitude, elevation: elevation);
      Geosphere sphereTo = Geosphere(
          latitude: to.latitude,
          longitude: to.longitude,
          elevation: to.elevation);
      Geosphere sphereMidpoint = Geosphere.fromMidpoint(sphereFrom, sphereTo);
      Geoellipseoid sphereoidMidpoint = Geoellipseoid(
          latitude: sphereMidpoint.latitude,
          longitude: sphereMidpoint.latitude,
          elevation: sphereMidpoint.elevation);

      Distance d = distanceTo(sphereoidMidpoint);
      d.meters += sphereoidMidpoint.distanceTo(to).meters;
      return d;
    }

    // c is the midpoint of the line segment (a,b)
    final c =
        Vector3((a[0] + b[0]) / 2.0, (a[1] + b[1]) / 2.0, (a[2] + b[2]) / 2.0);
    // find c in speroidal coordinates
    Geoellipseoid gc = Geoellipseoid.fromXYZ(c);
    // adjust the elevation to the middle of the two points.
    gc.elevation.meters = (elevation.meters + p.elevation.meters) / 2.0;

    final d = gc.toXYZ();

    double h = d.distanceTo(c);
    double el = arcSegmentLength(w, h);

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

  Geoellipseoid.fromMidpoint(Geoellipseoid p, Geoellipseoid q)
      : super(
            latitude: Angle.fromRadians(0),
            longitude: Angle.fromRadians(0),
            elevation: Distance.fromMeters(0)) {
    setFromMidpoint(this, p, q);
  }

  @override
  Geoellipseoid clone() => Geoellipseoid(
      latitude: latitude, longitude: longitude, elevation: elevation);
  @override
  Geosphere sphere() =>
      Geosphere(latitude: latitude, longitude: longitude, elevation: elevation);
  @override
  Geoellipseoid ellipseoid() => this;
}
