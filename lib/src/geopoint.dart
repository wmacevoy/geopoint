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
    if (1 + pow(chord / Geosphere.mean_earth_radius_in_meters, 2) == 1) {
      return chord;
    }
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

  static const String _sep = "_";
  static const String _patInteger = r"[0-9](_?[0-9])*";
  static const String _patNumber = "${_patInteger}(\\.${_patInteger})?";
  static const String _patSignedNumber = "[-+]?$_patNumber";
  static const String _patSignedNumberWithExponent =
      "$_patSignedNumber(e[-+]?${_patInteger})?";
  static const String _patElevation =
      "(?<ele${_sep}value>$_patSignedNumberWithExponent) ?(?<ele${_sep}unit>m(i(les?)?|(eters?)?)|f(t|eet|oot)|k(m|ilometers?))(?=[^a-z]|\\b)";
  static String _patSec(String of) => "(?<${of}${_sep}sec>$_patNumber)[s\"]";
  static String _patMinSec(String of) =>
      "(?<${of}${_sep}min>$_patNumber)[m'](${_patSec(of)})?";
  static String _patDegMinSec(String of) =>
      "(?<${of}${_sep}deg>$_patSignedNumber)([d°](${_patMinSec(of)})?)?";
  //"(?<${of}${_sep}deg>$_patNumber)d";
//      "(?<${of}${_sep}deg>$_patSignedNumber)[d°]((?<${of}${_sep}min>$_patNumber)[m'])?";
//      "(?<${of}${_sep}deg>$_patSignedNumber)([d°](${_patNumber}\m((?<${of}${_sep}sec>$_patNumber)[s\"])?)?)?";
//      "(?<${of}${_sep}deg>$_patSignedNumber)([d°](?<${of}${_sep}min>$_patNumber)[m']((?<${of}${_sep}sec>$_patNumber)[s\"])?)?";
  static final String _patLatitude =
      "${_patDegMinSec("lat")} ?(?<lat${_sep}dir>n(orth)?|s(outh)?)";
  static final String _patLongitude =
      "${_patDegMinSec("lon")} ?(?<lon${_sep}dir>e(ast)?|w(est)?)";
  static final String _patAny =
      "((?<ele>$_patElevation)|(?<lat>$_patLatitude)|(?<lon>$_patLongitude))";
  static RegExp _reAny = RegExp(_patAny);

  static void _testRe(RegExp re, List<String> ok, List<String> bad) {
    for (var s in ok) {
      final m = re.firstMatch(s);
      if (m == null || s != m[0]) {
        throw FormatException("$s did not match ${m == null ? "null" : m[0]}");
      }
    }
    for (var s in bad) {
      final m = re.firstMatch(s);
      if (m != null && m.start == 0 && m.end == s.length) {
        throw FormatException("$s should not match");
      }
    }
  }

  static void implTest() {
    RegExp reNumber = RegExp(_patNumber);
    _testRe(reNumber, [
      "0",
      "12",
      "1_234.5678_9101",
    ], [
      "1e10",
      "1e-10",
      "1e+10",
      "1_234.56e-9_876",
      "0.",
      ".0",
      "_0",
      "0_",
      "0__0",
      "0_.0",
      "0._0",
      "+1",
      "-1",
      "",
    ]);
    RegExp reSignedNumber = RegExp(_patSignedNumber);
    _testRe(reSignedNumber, [
      "0",
      "1",
      "-1",
      "+1",
    ], [
      "--0",
      "-_0",
      "-_",
    ]);
    RegExp reSignedNumberWithExponent = RegExp(_patSignedNumberWithExponent);
    _testRe(reSignedNumberWithExponent, [
      "1e10",
      "1e-10",
      "1e+10",
      "1_234.56e-9_876",
    ], [
      "1e",
      "1e+",
      "1e-",
    ]);
    RegExp reElevation = RegExp(_patElevation);
    _testRe(reElevation, [
      "1 ft",
      "0 foot",
      "0 feet",
      "1 mi",
      "1 mile",
      "1 miles",
      "2 m",
      "2 meter",
      "2 meters",
      "3 km",
      "3 kilometer",
      "3 kilometers",
    ], [
      "",
      "0 seconds",
      "0 millimeters",
    ]);
    RegExp reLatSec = RegExp(_patSec("lat"));
    _testRe(reLatSec, [
      "0s",
      "0\"",
      "0.00s",
    ], [
      "0",
    ]);
    RegExp reLatMinSec = RegExp(_patMinSec("lat"));
    _testRe(reLatMinSec, [
      "0m",
      "0'",
      "0m0s",
    ], [
      "0s",
    ]);
    RegExp reLatDMS = RegExp(_patDegMinSec("lat"));
    _testRe(reLatDMS, [
      "0",
      "-0",
      "+0",
      "0d",
      "0°",
      "0d0m",
      "0°0'",
      "0d0m0s",
      "0°0'0\"",
      "0d0m0.0000s",
      "0°0'0.0000\"",
    ], [
      "",
      "+",
      "-",
      "0m0s",
      "0m",
      "0s",
      "0d0s",
      "0d-0m0s",
      "0d-0m-0s",
    ]);
    // ignore: unused_local_variable
    RegExp reLonDMS = RegExp(_patDegMinSec("lon"));
    RegExp reLatitude = RegExp(_patLatitude);
    _testRe(reLatitude, [
      "0n",
      "0north",
      "0s",
      "0south",
      "0d0m0sn",
      "0d0m0snorth",
      "0d0m0ss",
      "0d0m0ssouth",
      "0 n",
      "0 north",
      "0 s",
      "0 south",
      "0d0m0s n",
      "0d0m0s north",
      "0d0m0s s",
      "0d0m0s south",
    ], []);
    RegExp reLongitude = RegExp(_patLongitude);
    _testRe(reLongitude, [
      "0e",
      "0east",
      "0w",
      "0west",
      "0d0m0se",
      "0d0m0seast",
      "0d0m0sw",
      "0d0m0swest",
      "0 e",
      "0 east",
      "0 w",
      "0 west",
      "0d0m0s e",
      "0d0m0s east",
      "0d0m0s w",
      "0d0m0s west",
    ], []);
    RegExp reAny = RegExp(_patAny);
  }

  static double _parseDouble(String str) {
    int sign = 1;
    if (str.startsWith('-') || str.startsWith('+')) {
      sign = str.startsWith('-') ? -1 : 1;
      str = str.substring(1);
    }
    str = str.replaceAll('_', '');
    return sign * double.parse(str);
  }

  static double _parseAngle(RegExpMatch m, String of) {
    String degStr = m.namedGroup("${of}${_sep}deg") ?? "0";
    String minStr = m.namedGroup("${of}${_sep}min") ?? "0";
    String secStr = m.namedGroup("${of}${_sep}sec") ?? "0";
    double deg = _parseDouble(degStr).abs();
    double min = _parseDouble(minStr);
    double sec = _parseDouble(secStr);
    int sgn = (degStr.startsWith("-") ? -1 : 1);
    double decDeg = deg + min / 60 + sec / 3600;
    return sgn * decDeg;
  }

  void _parseLatitude(RegExpMatch m) {
    String of = "lat";
    String dir = m.namedGroup("${of}${_sep}dir")!;
    int sgn = (dir == "s" || dir == "south") ? -1 : 1;
    latitude.degrees = sgn * _parseAngle(m, of);
  }

  void _parseLongitude(RegExpMatch m) {
    String of = "lon";
    String dir = m.namedGroup("${of}${_sep}dir")!;
    int sgn = (dir == "w" || dir == "west") ? -1 : 1;
    longitude.degrees = sgn * _parseAngle(m, of);
  }

  void _parseElevation(RegExpMatch m) {
    double value = _parseDouble(m.namedGroup("ele${_sep}value")!);
    String unit = m.namedGroup("ele${_sep}unit")!;
    elevation.setIn(value, unit);
  }

  void setFromString(String loc) {
    bool latSet = false;
    bool lonSet = false;
    bool eleSet = false;

    loc = loc.toLowerCase();

    for (var m in _reAny.allMatches(loc)) {
      String? latStr = m.namedGroup("lat");
      String? lonStr = m.namedGroup("lon");
      String? eleStr = m.namedGroup("ele");
      if (latStr != null) {
        if (latSet) throw FormatException("repeated latitude");
        _parseLatitude(m);
        latSet = true;
      }
      if (lonStr != null) {
        if (lonSet) throw FormatException("repeated longitude");
        _parseLongitude(m);
        lonSet = true;
      }
      if (eleStr != null) {
        if (eleSet) throw FormatException("repeated elevation");
        _parseElevation(m);
        eleSet = true;
      }
    }
    if (!(latSet && lonSet)) {
      throw FormatException("latitude and longitude not set");
    }
    if (!eleSet) {
      elevation.meters = 0;
    }
  }

  void implSetFromMidpoint(Geopoint p, Geopoint q);
  Geopoint clone();

  Geosphere sphere() =>
      Geosphere(latitude: latitude, longitude: longitude, elevation: elevation);
  Geoellipseoid ellipseoid() => Geoellipseoid(
      latitude: latitude, longitude: longitude, elevation: elevation);
}
