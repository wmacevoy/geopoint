import 'dart:math';
import 'package:geopoint/src/geosphere.dart';
import 'package:test/test.dart';
import 'near.dart';
import 'locations.dart';
import 'package:geopoint/src/geopoint.dart';

double cosm1(double x) {
  if (x.abs() < 1e-2) {
    return (-1.0 / 720.0) * pow(x, 6) +
        (1.0 / 24.0) * pow(x, 4) +
        (-1.0 / 2.0) * pow(x, 2);
  } else {
    return cos(x) - 1;
  }
}

void testGoldenSectionMinimize() {
  test('golden section minimize', () {
    for (double root in <double>[pi, sqrt(2), exp(1), -1, 0, 1, 5]) {
      for (double eps in <double>[1e-1, 1e-2, 1e-3, 1e-4, 1e-5, 1e-6, 1e-7]) {
        double f(double x) => (pow(x - root, 2) - pow(root, 2)).toDouble();
        double x = goldenSectionMinimize(f, -2, 23, eps);
        near(root, x, eps: eps, relative: false);
      }
    }
  });
}

void testArcSegmentLength() {
  test('cosm1', () {
    for (var x in <double>[1e-2 - 1e-6, 1e-2, 1e-2 + 1e-6, 1e-1]) {
      near(cos(x) - 1, cosm1(x), eps: 1e-6, relative: true);
    }
  });
  test('arclength', () {
    for (var r in <double>[1.0, 1e3, 1e-3, 1e6, 1e-6, 1e9, 1e-9]) {
      for (var theta in <double>[
        0,
        1e-14,
        1e-12,
        1e-10,
        1e-8,
        1e-6,
        1e-4,
        1e-2,
        1,
        pi / 2 - 1,
        pi / 2 - 1e-2,
        pi / 2 - 1e-4,
        pi / 2,
        pi / 2 + 1e-4,
        pi / 2 + 1e-2,
        pi / 2 + 1,
        pi - 1,
        pi - 1e-2,
        pi - 1e-4,
        pi,
        pi + 1e-4,
        pi + 1e-2,
        pi + 1,
        2 * pi - 1,
        2 * pi - 1e-2,
        2 * pi - 1e-4,
        2 * pi,
      ]) {
        double w = 2 * r * sin(theta / 2.0);
        double h = -r * cosm1(theta / 2.0);
        double result = arcSegmentLength(w, h);
        double expect = r * theta;
        near(expect, result, eps: 1e-13, relative: true);
      }
    }
  });
}

void testGeopoint() {
  test('grand junction to paris', () {
    final src = locations("grand junction, colorado");
    final dst = locations("paris, france");
    double km = src.distanceToInMeters(dst) / 1000.0;

    near(km, 8110, eps: 5e-3, relative: true);
  });

  test('grand junction to slc', () {
    final src = locations("grand junction, colorado");
    final dst = locations("salt lake city, utah");
    double km = src.distanceToInMeters(dst) / 1000.0;

    near(km, 343, eps: 5e-3, relative: true);
  });

  test('portland to paris', () {
    final src = locations("portland, oregon");
    final dst = locations("paris, france");
    double km = src.distanceToInMeters(dst) / 1000.0;

    near(km, 8268, eps: 5e-3, relative: true);
  });

  test('gj to portland', () {
    final src = locations("grand junction, colorado");
    final dst = locations("portland, oregon");
    double km = src.distanceToInMeters(dst) / 1000.0;

    near(1361, km, eps: 1e-2, relative: true);
  });

// https://www.movable-type.co.uk/scripts/latlong-vincenty.html
  test('flindlers to buninyong', () {
    final src = locations("flindlers peak, australia");
    final dst = locations("buninyong, australia");
    double km = src.distanceToInMeters(dst) / 1000.0;

    near(54.972271, km, eps: 1e-7, relative: true);
  });

  test('from to xyz at north spheroidal', () {
    for (var spherical in [true, false]) {
      for (var place in places()) {
        final location =
            spherical ? locations(place).sphere() : locations(place);
        if (place != "north") continue;
        if (spherical != false) continue;
        final xyz = location.toXYZ();
        final fromXYZ = location.clone();
        fromXYZ.latitude.degrees = 0;
        fromXYZ.longitude.radians = 0;
        fromXYZ.elevation.meters = 0;
        fromXYZ.setFromXYZ(xyz);
        near(location.elevation.meters / Geosphere.mean_earth_radius_in_meters,
            fromXYZ.elevation.meters,
            eps: 1e-13, relative: false);
        near(location.latitude.radians, fromXYZ.latitude.radians,
            eps: 1e-13, relative: false);
        near(location.longitude.radians, fromXYZ.longitude.radians,
            eps: 1e-13, relative: false);
      }
    }
  });

  test('from to xyz', () {
    for (var spherical in [true, false]) {
      for (var place in places()) {
        final location =
            spherical ? locations(place).sphere() : locations(place);
        final xyz = location.toXYZ();
        final fromXYZ = location.clone();
        fromXYZ.latitude.degrees = 0;
        fromXYZ.longitude.radians = 0;
        fromXYZ.elevation.meters = 0;
        fromXYZ.setFromXYZ(xyz);
        near(location.elevation.meters, fromXYZ.elevation.meters,
            eps: 1e-9, relative: true);
        near(location.latitude.radians, fromXYZ.latitude.radians,
            eps: 1e-9, relative: true);
        near(location.longitude.radians, fromXYZ.longitude.radians,
            eps: 1e-9, relative: true);
      }
    }
  });

  test('similar xyz', () {
    for (var srcName in places()) {
      Geopoint src = locations(srcName);
      var xyz1 = src.sphere().toXYZ();
      var xyz2 = src.ellipseoid().toXYZ();
      near(xyz1[0], xyz2[0], eps: 1e-2, relative: true);
      near(xyz1[1], xyz2[1], eps: 1e-2, relative: true);
      near(xyz1[2], xyz2[2], eps: 1e-2, relative: true);

      for (var dstName in places()) {
        if (dstName == srcName) continue;
        Geopoint dst = locations(dstName);
        var d1 = src.sphere().distanceToInMeters(dst.sphere());
        var d2 = src.ellipseoid().distanceToInMeters(dst.ellipseoid());
        near(d1, d2, eps: 1e-2, relative: true);
      }
    }
  });
}

void main() {
  testGoldenSectionMinimize();
  testArcSegmentLength();
  testGeopoint();
}
