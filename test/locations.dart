import 'package:geopoint/src/geoellipseoid.dart';
import 'package:geopoint/src/measure.dart';
import 'package:geopoint/src/geopoint.dart';

List<String> places() {
  return <String>[
    "portland, oregon",
    "grand junction, colorado",
    "salt lake city, utah",
    "paris, france",
    "montrose, colorado",
    "north",
    "east",
    "west",
    "south",
  ];
}

Geoellipseoid locations(String city) {
  switch (city) {
    case "portland, oregon":
      return Geoellipseoid(
          latitude: Angle.fromDegMinSec(45, 32, 13),
          longitude: Angle.fromDegMinSec(-122, 39, 0),
          elevation: Distance.fromFeet(50));
    case "grand junction, colorado":
      return Geoellipseoid(
          latitude: Angle.fromDegMinSec(39, 5, 11),
          longitude: Angle.fromDegMinSec(-108, 34, 7),
          elevation: Distance.fromFeet(4583));
    case "salt lake city, utah":
      return Geoellipseoid(
          latitude: Angle.fromDegMinSec(40, 46, 43),
          longitude: Angle.fromDegMinSec(-111, 55, 53),
          elevation: Distance.fromFeet(4226));
    case "montrose, colorado":
      return Geoellipseoid(
          latitude: Angle.fromDegMinSec(38, 28, 9),
          longitude: Angle.fromDegMinSec(-107, 51, 38),
          elevation: Distance.fromFeet(5807));
    case "paris, france":
      return Geoellipseoid(
          latitude: Angle.fromDegMinSec(48, 51, 36),
          longitude: Angle.fromDegMinSec(2, 20, 24),
          elevation: Distance.fromMeters(35));
    case "flindlers peak, australia":
      return Geoellipseoid(
          latitude: Angle.fromDegMinSec(-37, 57, 3.72030),
          longitude: Angle.fromDegMinSec(144, 25, 29.52440),
          elevation: Distance.fromMeters(0.0));
    case "buninyong, australia":
      return Geoellipseoid(
          latitude: Angle.fromDegMinSec(-37, 39, 10.15610),
          longitude: Angle.fromDegMinSec(143, 55, 35.38390),
          elevation: Distance.fromMeters(0.0));
    case "north":
      return Geoellipseoid(
          latitude: Angle.fromDegMinSec(90, 0, 0),
          longitude: Angle.fromDegMinSec(0, 0, 0),
          elevation: Distance.fromMeters(0.0));
    case "south":
      return Geoellipseoid(
          latitude: Angle.fromDegMinSec(-90, 0, 0),
          longitude: Angle.fromDegMinSec(0, 0, 0),
          elevation: Distance.fromMeters(0.0));
    case "east":
      return Geoellipseoid(
          latitude: Angle.fromDegMinSec(0, 0, 0),
          longitude: Angle.fromDegMinSec(90, 0, 0),
          elevation: Distance.fromMeters(0.0));
    case "west":
      return Geoellipseoid(
          latitude: Angle.fromDegMinSec(0, 0, 0),
          longitude: Angle.fromDegMinSec(-90, 0, 0),
          elevation: Distance.fromMeters(0.0));
  }
  throw Exception("no such city");
}
