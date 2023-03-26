import 'dart:io';
import 'dart:convert';

import 'dart:math';
import 'package:test/test.dart';
import 'locations.dart';
import 'package:geopoint/src/geopoint.dart';
import 'package:geopoint/src/measure.dart' as measure;
import 'package:intl/intl.dart';

// https://geographiclib.sourceforge.io/C++/doc/geodesic.html#testgeod

int pwr(double x, {int digits = 1}) {
  var xStr = x.toStringAsExponential(max(0, digits));
  return int.parse(xStr.substring(xStr.indexOf('e') + 1));
}

String man(double x, {int digits = 1}) {
  var xStr = x.toStringAsExponential(max(0, digits));
  var m = xStr.substring(0, xStr.indexOf('e'));
  if (digits == -1 && m == "1") return "";
  return "${m}×";
}

String sci(num x, {int digits = 1}) {
  double y = x.toDouble();
  return "${man(y, digits: digits)}10<sup>${pwr(y, digits: digits)}</sup>";
}

num? maxVal(Iterable<num> all) {
  num? ans;
  for (num x in all) {
    if (ans == null || ans < x) {
      ans = x;
    }
  }
  return ans;
}

num? minVal(Iterable<num> all) {
  num? ans;
  for (num x in all) {
    if (ans == null || ans > x) {
      ans = x;
    }
  }
  return ans;
}

class Rec {
//  latitude at point 1, lat1 (degrees, exact)
//  longitude at point 1, lon1 (degrees, always 0)
//  azimuth at point 1, azi1 (clockwise from north in degrees, exact)
//  latitude at point 2, lat2 (degrees, accurate to 10−18 deg)
//  longitude at point 2, lon2 (degrees, accurate to 10−18 deg)
//  azimuth at point 2, azi2 (degrees, accurate to 10−18 deg)
//  geodesic distance from point 1 to point 2, s12 (meters, exact)
//  arc distance on the auxiliary sphere, a12 (degrees, accurate to 10−18 deg)
//  reduced length of the geodesic, m12 (meters, accurate to 0.1 pm)
//  the area under the geodesic, S12 (m2, accurate to 1 mm2)
  double eps;
  int row = 0;

  final Geopoint a;
  final measure.Angle aAzimuth = measure.Angle.fromDegrees(0);
  final Geopoint b;
  final measure.Angle bAzimuth = measure.Angle.fromDegrees(0);
  final measure.Distance geodesic = measure.Distance.fromMeters(0);
  final measure.Distance arcdist = measure.Distance.fromMeters(0);
  final measure.Distance reduced = measure.Distance.fromMeters(0);
  double areaM2 = 0.0;
  int bin;
  Rec(Geopoint basis)
      : a = basis.clone(),
        b = basis.clone(),
        eps = 1,
        bin = 0 {
    while (1 + eps / 2 != 1) {
      eps = eps / 2;
    }
  }

  set data(List<double> data) {
    int c = 0;
    a.latitude.degrees = data[c++];
    a.longitude.degrees = data[c++];
    a.elevation.meters = 0.0;
    aAzimuth.degrees = data[c++];
    b.latitude.degrees = data[c++];
    b.longitude.degrees = data[c++];
    b.elevation.meters = 0.0;
    bAzimuth.degrees = data[c++];
    geodesic.meters = data[c++];
    arcdist.meters = data[c++];
    reduced.meters = data[c++];
    areaM2 = data[c++];
  }

  int tests = 0;
  Map<int, double> maxRelErrors = Map<int, double>();
  Map<int, double> maxResErrors = Map<int, double>();
  Map<int, int> counts = Map<int, int>();

  void process(String line) {
    var strCols = line.split(" ");
    List<double> cols = <double>[];
    for (String strCol in strCols) {
      cols.add(double.parse(strCol));
    }
    data = cols;
    test();
  }

  void resErr(Geopoint p) {
    final xyz = p.toXYZ();
    final q = p.clone();
    double err = 0;
    for (var dlat in [1 - eps, 1 + eps]) {
      for (var dlon in [1 - eps, 1 + eps]) {
        q.latitude.radians = p.latitude.radians * dlat;
        q.longitude.radians = p.longitude.radians * dlon;
        err = max(err, q.toXYZ().distanceTo(xyz));
      }
    }
    maxResErrors[bin] = err / geodesic.meters;
  }

  void test() {
    double expect = geodesic.meters;
    bin = pwr(expect, digits: 0);
    double oldMax = maxRelErrors[bin] ?? 0.0;
    int oldCount = counts[bin] ?? 0;
    double ab = a.distanceToInMeters(b);
    resErr(a);
    resErr(b);
    double relErr = (ab - expect).abs() / expect;
    maxRelErrors[bin] = max(oldMax, relErr);
    counts[bin] = oldCount + 1;
    ++tests;
  }

  double maxRelErrorsInRange(int minBin, int maxBin) {
    double value = 0;
    for (var bin in maxRelErrors.keys) {
      if (minBin <= bin && bin < maxBin) {
        value = max(value, maxRelErrors[bin] ?? 0.0);
      }
    }
    return value;
  }

  int countInRange(int minBin, int maxBin) {
    int count = 0;
    for (var bin in counts.keys) {
      if (minBin <= bin && bin < maxBin) {
        count = count + (counts[bin] ?? 0);
      }
    }
    return count;
  }
}

double testErr(bool sphere) => sphere ? 1e-2 : 1e-5;
Future<void> testAll(bool sphere) async {
  final place = locations("grand junction, colorado").ellipseoid();
  final basis = sphere ? place.sphere() : place.ellipseoid();
  var rec = Rec(basis);
  var err = testErr(sphere);
  var fileName = "test/data/GeodTest.dat";
  var file = File(fileName);
  expect(await file.exists(), equals(true));

  var lines =
      file.openRead().transform(utf8.decoder).transform(const LineSplitter());
  Random rng = Random();
  await lines.forEach((line) {
    if (rng.nextInt(100) < 100) rec.process(line);
  });

  List<int> bins = rec.maxRelErrors.keys.toList();
  bins.sort();

  var formatter = NumberFormat.decimalPattern();

  for (var bin in bins) {
    var re = rec.maxRelErrors[bin] ?? 0;
    var de = rec.maxResErrors[bin] ?? 0;

    print(
        "| ${sci(re)} | ${sci(de)} | ${sci(pow(10.0, bin), digits: -1)} m ≤ d < ${sci(pow(10.0, bin + 1), digits: -1)} m  | ${formatter.format(rec.counts[bin])} |");
  }

  int minBin = minVal(rec.maxRelErrors.keys) as int;
  int maxBin = (maxVal(rec.maxRelErrors.keys) as int);
  double re = rec.maxRelErrorsInRange(minBin, maxBin + 1);
  int c = rec.countInRange(minBin, maxBin + 1);
  final cstr = formatter.format(c);
  print(
      "| ${sci(re)} | | ${sci(pow(10.0, minBin), digits: -1)} m ≤ d < ${sci(pow(10.0, maxBin + 1), digits: -1)} m  | ${cstr}");

  // less than 1e-7 rel err for 0.01 m (1cm) .. 1,000,000 m (1,000 km)
  expect(re, lessThan(err));
}

testGeopointDist() {
  test('max ellipseoid relative error < 1e-5 for dist 1 mm or greater',
      () async {
    final sphere = false;
    expect(testErr(sphere), lessThanOrEqualTo(1e-5));
    await testAll(sphere);
  }, timeout: Timeout(Duration(minutes: 1)));

  test('max sphere relative error < 1e-2 for dist 1 mm or greater', () async {
    final sphere = true;
    expect(testErr(sphere), lessThanOrEqualTo(1e-2));
    await testAll(sphere);
  }, timeout: Timeout(Duration(minutes: 1)));
}

void main() {
  testGeopointDist();
}
