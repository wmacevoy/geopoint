import 'dart:math';

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

void testGeopoint() {
  test('grand junction to paris', () {
    final src = locations("grand junction, colorado");
    final dst = locations("paris, france");
    // final avg = (src.elevation.meters + dst.elevation.meters) / 2.0;
    // src.elevation.meters = avg;
    // dst.elevation.meters = avg;
    double km = src.distanceInMeters(dst) / 1000.0;

    near(km, 8110, eps: 5e-3, relative: true);
  });

  test('grand junction to slc', () {
    final src = locations("grand junction, colorado");
    final dst = locations("salt lake city, utah");
    double km = src.distanceInMeters(dst) / 1000.0;

    near(km, 343, eps: 5e-3, relative: true);
  });

  test('portland to paris', () {
    final src = locations("portland, oregon");
    final dst = locations("paris, france");
    double km = src.distanceInMeters(dst) / 1000.0;

    near(km, 8268, eps: 5e-3, relative: true);
  });

  test('gj to portland', () {
    final src = locations("grand junction, colorado");
    final dst = locations("portland, oregon");
    double km = src.distanceInMeters(dst) / 1000.0;

    near(1361, km, eps: 1e-2, relative: true);
  });

// https://www.movable-type.co.uk/scripts/latlong-vincenty.html
  test('flindlers to buninyong', () {
    final src = locations("flindlers peak, australia");
    final dst = locations("buninyong, australia");
    double km = src.distanceInMeters(dst) / 1000.0;

    near(54.972271, km, eps: 1e-7, relative: true);
  });

  test('arclength', () {
    for (var r in <double>[1.0, 1e3, 1e-3, 1e6, 1e-6, 1e9, 1e-9]) {
      for (var phi in <double>[
        pi / 2,
        1e-1,
        1e-2,
        1e-3,
        1e-4,
        1e-5,
        1e-6,
        1e-9
      ]) {
        double w = 2 * r * sin(phi / 2.0);
        double h = -r * cosm1(phi / 2.0);
        double el = Geopoint.arcSegmentLength(w, h);
        double d = r * phi;
        near(d, el, eps: 1e-12, relative: true);
      }
    }
  });

  test('spheroidal xyz', () {
    for (var place in places()) {
      Geopoint location = locations(place);
      var xyz = location.toSpheroidalXYZ();
      Geopoint fromXYZ = Geopoint.fromSpheroidalXYZ(xyz);
      near(location.elevation.meters, fromXYZ.elevation.meters,
          eps: 1e-6, relative: true);
      near(location.latitude.radians, fromXYZ.latitude.radians,
          eps: 1e-9, relative: true);
      near(location.longitude.radians, fromXYZ.longitude.radians,
          eps: 1e-9, relative: true);
    }
  });

  test('spherical xyz', () {
    for (var place in places()) {
      Geopoint location = locations(place);
      var xyz = location.toSphericalXYZ();
      Geopoint fromXYZ = Geopoint.fromSphericalXYZ(xyz);
      near(location.elevation.meters, fromXYZ.elevation.meters,
          eps: 1e-6, relative: true);
      near(location.latitude.radians, fromXYZ.latitude.radians,
          eps: 1e-9, relative: true);
      near(location.longitude.radians, fromXYZ.longitude.radians,
          eps: 1e-9, relative: true);
    }
  });

  test('similar xyz', () {
    for (var srcName in places()) {
      Geopoint src = locations(srcName);
      var xyz1 = src.toSphericalXYZ();
      var xyz2 = src.toSpheroidalXYZ();
      near(xyz1[0], xyz2[0], eps: 1e-2, relative: true);
      near(xyz1[1], xyz2[1], eps: 1e-2, relative: true);
      near(xyz1[2], xyz2[2], eps: 1e-2, relative: true);

      for (var dstName in places()) {
        if (dstName == srcName) continue;
        Geopoint dst = locations(dstName);
        var d1 = src.sphericalDistanceInMeters(dst);
        var d2 = src.sphericalDistanceInMeters(dst);
        near(d1, d2, eps: 1e-2, relative: true);
      }
    }
  });
}

void main() {
  testGeopoint();
}
