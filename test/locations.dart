import 'package:geopoint/src/geoellipseoid.dart';
import 'package:geopoint/src/measure.dart';

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

String strLocations(String city) {
  switch (city) {
    case "portland, oregon":
      return "45°32'13\"N 122°39'0\"W 50ft";
    case "grand junction, colorado":
      return "39°5'11\"N 108°34'7\"W 4583ft";
    case "salt lake city, utah":
      return "40°46'43\"N 111°55'53\"W 4226ft";
    case "montrose, colorado":
      return "38°28'9\"N 107°51'38\"W 5807ft";
    case "paris, france":
      return "48°51'36\"N 2°20'24\"E 35m";
    case "flindlers peak, australia":
      return "37°57'3.72030\"S 144°25'29.52440\"E";
    case "buninyong, australia":
      return "37°39'10.15610\"S 143°55'35.38390\"E";
    case "north":
      return "90°N 0°W";
    case "south":
      return "90°S 0°E";
    case "east":
      return "0°N 90°E";
    case "west":
      return "0°N 90°W";
  }
  throw Exception("no such city");
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
