import 'package:geopoint/src/geoellipseoid.dart';
import 'package:geopoint/src/geopoint.dart';

void main(List<String> args) {
  Geopoint locFrom = Geoellipseoid.fromString("90°N 0°E 0m");
  Geopoint locTo = Geoellipseoid.fromString("90°S 0°E 0m");
  String units = "km";

  if (args.length == 0) {
    print("examples:");
    print(
        "from '0N 0E' to '0N 180E' ? # halfway around equator from prime meridian on wgs84 ellipseoid");
    print(
        "from '0N 0E' to '0N 180E' units miles ? # in miles on wgs84 ellipseoid");
    print(
        "sphere from '0N 0E' to '0N 180E' units miles ? # in miles on sphere");
    print(
        "from '27°59m9.8340sN 86°55m21.4428sE 29_032ft' to '27.7172N 85.3240E 4_593ft' units kilometers ? # everest to kathmandu in km");
  }

  for (int i = 0; i < args.length; ++i) {
    if (args[i] == "sphere") {
      locFrom = locFrom.sphere();
      locTo = locTo.sphere();
      continue;
    }
    if (args[i] == "ellipsoid" || args[i] == "wgs84") {
      locFrom = locFrom.ellipseoid();
      locTo = locTo.ellipseoid();
      continue;
    }
    if (args[i] == "from") {
      ++i;
      locFrom.setFromString(args[i]);
      continue;
    }
    if (args[i] == "to") {
      ++i;
      locFrom.setFromString(args[i]);
      continue;
    }
    if (args[i] == "units") {
      ++i;
      units = args[i];
      continue;
    }
    if (args[i] == "?") {
      print("${locFrom.distanceTo(locTo).getIn(units)} ${units}");
    }
  }
}
