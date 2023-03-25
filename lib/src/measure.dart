import 'dart:math' as math;
import 'from_to_map.dart';

// see equatable for == and != hashCode stuff

mixin Measure on FromToMap {
  String get coreUnitsIn;
  Set<String> get allowedUnits;
  double get coreUnits;
  double get default_core_units => 0.0;
  @override
  void reset() {
    coreUnits = default_core_units;
  }

  set coreUnits(double value);
  double getIn(String unit);
  void setIn(double value, String unit);
  @override
  Map<String, dynamic> toMap() => {coreUnitsIn: getIn(coreUnitsIn)};

  @override
  void updateWithMap(Map<String, dynamic> map) {
    bool updated = false;
    Set<String> allowed = allowedUnits;
    for (var kv in map.entries) {
      if (allowed.contains(kv.key)) {
        if (!updated) {
          setIn(kv.value.toDouble(), kv.key);
          updated = true;
        } else {
          throw ArgumentError("value set in more than one unit");
        }
      }
    }
  }
}

class Percentage extends FromToMap with Measure {
  Percentage();
  late double _fraction = default_core_units;
  @override
  double get coreUnits {
    return _fraction;
  }

  @override
  set coreUnits(double x) {
    _fraction = x;
  }

  double get fraction {
    return coreUnits;
  }

  set fraction(double x) {
    coreUnits = x;
  }

  Percentage.fromFraction(double x) {
    fraction = x;
  }

  double get percent {
    return fraction * 100.0;
  }

  set percent(double p) {
    fraction = p / 100.0;
  }

  Percentage.fromPercent(double p) {
    percent = p;
  }

  @override
  double getIn(String unit) {
    switch (unit) {
      case "unitless":
      case "fraction":
        return fraction;
      case "%":
      case "percent":
      case "percentage":
        return percent;
    }
    throw ArgumentError("unsupported unit");
  }

  @override
  void setIn(double value, String unit) {
    switch (unit) {
      case "unitless":
      case "fraction":
        {
          fraction = value;
          return;
        }
      case "%":
      case "percent":
      case "percentage":
        {
          percent = value;
          return;
        }
    }
    throw ArgumentError("unsupported unit");
  }

  Percentage.fromMap(Map<String, dynamic>? map) {
    setWithMap(map);
  }

  @override
  Percentage Function(Map<String, dynamic>? map) get fromMapFactory {
    return Percentage.fromMap;
  }

  static final Set<String> _allowedUnits = {
    "unitless",
    "fraction",
    "%",
    "percent",
    "percentage",
  };

  @override
  Set<String> get allowedUnits {
    return _allowedUnits;
  }

  @override
  String get coreUnitsIn {
    return "fraction";
  }
}

class Temperature extends FromToMap with Measure {
  Temperature();

  late double _celsius = default_core_units;
  @override
  double get coreUnits {
    return _celsius;
  }

  @override
  set coreUnits(double c) {
    _celsius = c;
  }

  double get celsius {
    return coreUnits;
  }

  set celsius(double c) {
    coreUnits = c;
  }

  Temperature.fromCelsius(double c) {
    celsius = c;
  }

  double get fahrenheit {
    return 1.8 * celsius + 32.0;
  }

  set fahrenheit(double f) {
    celsius = (f - 32.0) / 1.8;
  }

  Temperature.fromFahrenheit(double f) {
    fahrenheit = f;
  }

  double get kelvin {
    return celsius + 273.15;
  }

  set kelvin(double k) {
    celsius = k - 273.15;
  }

  Temperature.fromKelvin(double k) {
    kelvin = k;
  }

  @override
  double getIn(String unit) {
    switch (unit) {
      case "c":
      case "celsius":
        return celsius;
      case "f":
      case "fahrenheit":
        return fahrenheit;
      case "k":
      case "kelvin":
        return kelvin;
    }
    throw ArgumentError("unsupported unit");
  }

  @override
  void setIn(double value, String unit) {
    switch (unit) {
      case "c":
      case "celsius":
        {
          celsius = value;
          return;
        }
      case "f":
      case "fahrenheit":
        {
          fahrenheit = value;
          return;
        }
      case "k":
      case "kelvin":
        {
          kelvin = value;
          return;
        }
    }
    throw ArgumentError("unsupported unit");
  }

  Temperature.fromMap(Map<String, dynamic>? map) {
    setWithMap(map);
  }

  @override
  Temperature Function(Map<String, dynamic>? map) get fromMapFactory {
    return Temperature.fromMap;
  }

  static final Set<String> _allowedUnits = {
    "c",
    "celsius",
    "f",
    "fahrenheit",
    "k",
    "kelvin"
  };

  @override
  Set<String> get allowedUnits {
    return _allowedUnits;
  }

  @override
  String get coreUnitsIn {
    return "celsius";
  }
}

class Distance extends FromToMap with Measure {
  Distance();

  late double _meters = default_core_units;

  @override
  double get coreUnits {
    return _meters;
  }

  @override
  set coreUnits(double m) {
    _meters = m;
  }

  double get meters {
    return coreUnits;
  }

  set meters(double m) {
    coreUnits = m;
  }

  Distance.fromMeters(double m) {
    meters = m;
  }

  double get centimeters {
    return 100.0 * meters;
  }

  set centimeters(double cm) {
    meters = cm / 100.0;
  }

  Distance.fromCentimeters(double cm) {
    centimeters = cm;
  }

  double get millimeters {
    return 1000.0 * meters;
  }

  set millimeters(double mm) {
    meters = mm / 1000.0;
  }

  Distance.fromMillimeters(double mm) {
    millimeters = mm;
  }

  double get kilometers {
    return meters / 1000.0;
  }

  set kilometers(double km) {
    meters = km * 1000.0;
  }

  Distance.fromKilometers(double km) {
    kilometers = km;
  }

  double get inches {
    return centimeters / 2.54;
  }

  set inches(double _in) {
    centimeters = _in * 2.54;
  }

  Distance.fromInches(double _in) {
    inches = _in;
  }

  double get feet {
    return inches / 12.0;
  }

  set feet(double ft) {
    inches = ft * 12.0;
  }

  Distance.fromFeet(double ft) {
    feet = ft;
  }

  double get yards {
    return feet / 3.0;
  }

  set yards(double yd) {
    feet = yd * 3.0;
  }

  Distance.fromYards(double yd) {
    yards = yd;
  }

  double get miles {
    return feet / 5280.0;
  }

  set miles(double mi) {
    feet = mi * 5280.0;
  }

  Distance.fromMiles(double mi) {
    miles = mi;
  }

  @override
  double getIn(String unit) {
    switch (unit) {
      case "m":
      case "meters":
      case "meter":
        return meters;
      case "cm":
      case "centimeters":
      case "centimeter":
        return centimeters;
      case "mm":
      case "millimeters":
      case "millimeter":
        return millimeters;
      case "km":
      case "kilometers":
      case "kilometer":
        return kilometers;
      case "in":
      case "inches":
      case "inch":
        return inches;
      case "ft":
      case "feet":
      case "foot":
        return feet;
      case "yd":
      case "yards":
      case "yard":
        return yards;
      case "mi":
      case "miles":
      case "mile":
        return miles;
    }
    throw ArgumentError("unsupported unit");
  }

  @override
  void setIn(double value, String unit) {
    switch (unit) {
      case "m":
      case "meters":
      case "meter":
        {
          meters = value;
          return;
        }
      case "cm":
      case "centimeters":
      case "centimeter":
        {
          centimeters = value;
          return;
        }
      case "mm":
      case "millimeters":
      case "millimeter":
        {
          millimeters = value;
          return;
        }
      case "km":
      case "kilometers":
      case "kilometer":
        {
          kilometers = value;
          return;
        }
      case "in":
      case "inches":
      case "inch":
        {
          inches = value;
          return;
        }
      case "ft":
      case "feet":
      case "foot":
        {
          feet = value;
          return;
        }
      case "yd":
      case "yards":
      case "yard":
        {
          yards = value;
          return;
        }
      case "mi":
      case "miles":
      case "mile":
        {
          miles = value;
          return;
        }
    }
    throw ArgumentError("unsupported unit");
  }

  Distance.fromMap(Map<String, dynamic>? map) {
    setWithMap(map);
  }

  @override
  Distance Function(Map<String, dynamic>? json) get fromMapFactory {
    return Distance.fromMap;
  }

  static final Set<String> _allowedUnits = {
    "m",
    "meters",
    "meter",
    "cm",
    "centimeters",
    "centimeter",
    "mm",
    "millimeters",
    "millimeter",
    "km",
    "kilometers",
    "kilometer",
    "in",
    "inches",
    "inch",
    "ft",
    "feet",
    "foot",
    "yd",
    "yards",
    "yard",
    "mi",
    "miles",
    "mile"
  };

  @override
  Set<String> get allowedUnits {
    return _allowedUnits;
  }

  @override
  String get coreUnitsIn {
    return "meters";
  }
}

class Duration extends FromToMap with Measure {
  Duration();

  late double _seconds = default_core_units;

  @override
  double get coreUnits {
    return _seconds;
  }

  @override
  set coreUnits(double s) {
    _seconds = s;
  }

  double get seconds {
    return coreUnits;
  }

  set seconds(double s) {
    coreUnits = s;
  }

  Duration.fromSeconds(double s) {
    seconds = s;
  }

  double get milliseconds {
    return seconds * 1000.0;
  }

  set milliseconds(double ms) {
    seconds = ms / 1000.0;
  }

  Duration.fromMilliseconds(double ms) {
    milliseconds = ms;
  }

  double get microseconds {
    return seconds * 1000000.0;
  }

  set microseconds(double us) {
    seconds = us / 1000000.0;
  }

  Duration.fromMicroseconds(double us) {
    microseconds = us;
  }

  double get minutes {
    return seconds / 60.0;
  }

  set minutes(double m) {
    seconds = m * 60.0;
  }

  Duration.fromMinutes(double m) {
    minutes = m;
  }

  double get hours {
    return minutes / 60.0;
  }

  set hours(double h) {
    minutes = h * 60.0;
  }

  Duration.fromHours(double h) {
    hours = h;
  }

  @override
  double getIn(String unit) {
    switch (unit) {
      case "s":
      case "seconds":
      case "second":
        return seconds;
      case "ms":
      case "milliseconds":
      case "millisecond":
        return milliseconds;
      case "us":
      case "microseconds":
      case "microsecond":
        return microseconds;
      case "m":
      case "minutes":
      case "minute":
        return minutes;
      case "h":
      case "hours":
      case "hour":
        return hours;
    }
    throw ArgumentError("unsupported unit");
  }

  @override
  void setIn(double value, String unit) {
    switch (unit) {
      case "s":
      case "seconds":
      case "second":
        {
          seconds = value;
          return;
        }
      case "ms":
      case "milliseconds":
      case "millisecond":
        {
          milliseconds = value;
          return;
        }
      case "us":
      case "microseconds":
      case "microsecond":
        {
          microseconds = value;
          return;
        }
      case "m":
      case "minutes":
      case "minute":
        {
          minutes = value;
          return;
        }
      case "h":
      case "hours":
      case "hour":
        {
          hours = value;
          return;
        }
    }
    throw ArgumentError("unsupported unit");
  }

  Duration.fromMap(Map<String, dynamic>? map) {
    setWithMap(map);
  }

  @override
  Duration Function(Map<String, dynamic>? map) get fromMapFactory {
    return Duration.fromMap;
  }

  static final Set<String> _allowedUnits = {
    "s",
    "seconds",
    "second",
    "ms",
    "milliseconds",
    "millisecond",
    "us",
    "microseconds",
    "microsecond",
    "m",
    "minutes",
    "minute",
    "h",
    "hours",
    "hour"
  };

  @override
  Set<String> get allowedUnits {
    return _allowedUnits;
  }

  @override
  String get coreUnitsIn {
    return "seconds";
  }
}

class Pressure extends FromToMap with Measure {
  Pressure();
  static const double _default_core_units = 100000.0;
  @override
  get default_core_units => _default_core_units;

  late double _pascals = default_core_units;

  @override
  double get coreUnits {
    return _pascals;
  }

  @override
  set coreUnits(double pa) {
    _pascals = pa;
  }

  double get pascals {
    return coreUnits;
  }

  set pascals(double pa) {
    coreUnits = pa;
  }

  Pressure.fromPascals(double pa) {
    pascals = pa;
  }

  double get kilopascals {
    return pascals / 1000.0;
  }

  set kilopascals(double kpa) {
    pascals = kpa * 1000.0;
  }

  Pressure.fromKilopascals(double kpa) {
    kilopascals = kpa;
  }

  double get bar {
    return pascals / 100000.0;
  }

  set bar(double bar) {
    pascals = bar * 100000.0;
  }

  Pressure.fromBar(double bar) {
    this.bar = bar;
  }

  double get inHg {
    return pascals / 3386.389;
  }

  set inHg(double im) {
    pascals = im * 3386.389;
  }

  Pressure.fromInHg(double im) {
    inHg = im;
  }

  @override
  double getIn(String unit) {
    switch (unit) {
      case "pa":
      case "pascals":
      case "pascal":
        return pascals;
      case "kpa":
      case "kilopascals":
      case "kilopascal":
        return kilopascals;
      case "bar":
        return bar;
      case "in-hg":
        return inHg;
    }
    throw ArgumentError("unsupported unit");
  }

  @override
  void setIn(double value, String unit) {
    switch (unit) {
      case "pa":
      case "pascals":
      case "pascal":
        {
          pascals = value;
          return;
        }
      case "kpa":
      case "kilopascals":
      case "kilopascal":
        {
          kilopascals = value;
          return;
        }
      case "bar":
        {
          bar = value;
          return;
        }
      case "in-hg":
        {
          inHg = value;
          return;
        }
    }
    throw ArgumentError("unsupported unit");
  }

  Pressure.fromMap(Map<String, dynamic>? map) {
    setWithMap(map);
  }

  @override
  Pressure Function(Map<String, dynamic>? map) get fromMapFactory {
    return Pressure.fromMap;
  }

  static final Set<String> _allowedUnits = {
    "pa",
    "pascals",
    "pascal",
    "kpa",
    "kilopascals",
    "kilopascal",
    "bar",
    "in-hg"
  };

  @override
  Set<String> get allowedUnits {
    return _allowedUnits;
  }

  @override
  String get coreUnitsIn {
    return "pascals";
  }
}

class Angle extends FromToMap with Measure {
  Angle();

  late double _radians = default_core_units;

  @override
  double get coreUnits {
    return _radians;
  }

  @override
  set coreUnits(double rad) {
    _radians = rad;
  }

  double get radians {
    return coreUnits;
  }

  set radians(double rad) {
    coreUnits = rad;
  }

  Angle.fromRadians(double rad) {
    radians = rad;
  }

  double get degrees {
    return radians * (180.0 / math.pi);
  }

  set degrees(double deg) {
    radians = deg / (180.0 / math.pi);
  }

  Angle.fromDegrees(double deg) {
    degrees = deg;
  }

  Angle.fromDegMinSec(num deg, num min, num sec) {
    bool negative = (deg < 0.0 ||
        (deg == 0.0 && min < 0.0) ||
        (deg == 0.0 && min == 0.0 && sec < 0.0));
    degrees = (negative ? -1.0 : 1.0) *
        (deg.abs() + min.abs() / 60.0 + sec.abs() / 3600.0);
  }

  double get revolutions {
    return degrees / 360.0;
  }

  set revolutions(double r) {
    degrees = r * 360.0;
  }

  Angle.fromRevolutions(double r) {
    revolutions = r;
  }

  double get minutesOfArc {
    return degrees * 60.0;
  }

  set minutesOfArc(double moa) {
    degrees = moa / 60.0;
  }

  Angle.fromMinutesOfArc(double moa) {
    minutesOfArc = moa;
  }

  @override
  double getIn(String unit) {
    switch (unit) {
      case "rad":
      case "radians":
      case "radian":
        return radians;
      case "deg":
      case "degrees":
      case "degree":
        return degrees;
      case "rev":
      case "revolutions":
      case "revolution":
        return revolutions;
      case "moa":
      case "minutesofarc":
      case "minuteofarc":
        return minutesOfArc;
    }
    throw ArgumentError("unsupported unit");
  }

  @override
  void setIn(double value, String unit) {
    switch (unit) {
      case "rad":
      case "radians":
      case "radian":
        {
          radians = value;
          return;
        }
      case "deg":
      case "degrees":
      case "degree":
        {
          degrees = value;
          return;
        }
      case "rev":
      case "revolutions":
      case "revolution":
        {
          revolutions = value;
          return;
        }
      case "moa":
      case "minutesofarc":
      case "minuteofarc":
        {
          minutesOfArc = value;
          return;
        }
    }
    throw ArgumentError("unsupported unit");
  }

  Angle.fromMap(Map<String, dynamic>? map) {
    setWithMap(map);
  }

  @override
  Angle Function(Map<String, dynamic>? json) get fromMapFactory {
    return Angle.fromMap;
  }

  static final Set<String> _allowedUnits = {
    "rad",
    "radians",
    "radian",
    "deg",
    "degrees",
    "degree",
    "rev",
    "revolutions",
    "revolution",
    "moa",
    "minutesofarc",
    "minuteofarc"
  };

  @override
  Set<String> get allowedUnits {
    return _allowedUnits;
  }

  @override
  String get coreUnitsIn {
    return "radians";
  }

  double get sin {
    return math.sin(radians);
  }

  set sin(double s) {
    radians = math.asin(s);
  }

  Angle.fromSin(double s) : this.fromRadians(math.asin(s));

  double get cos {
    return math.cos(radians);
  }

  set cos(double c) {
    radians = math.acos(c);
  }

  Angle.fromCos(double c) : this.fromRadians(math.acos(c));

  double get tan {
    return math.tan(radians);
  }

  set tan(double t) {
    radians = math.atan(t);
  }

  atan2(double y, double x) {
    radians = math.atan2(y, x);
  }

  Angle.fromTan(double t) : this.fromRadians(math.atan(t));
}

class Mass extends FromToMap with Measure {
  Mass();

  late double _grams = default_core_units;

  @override
  double get coreUnits {
    return _grams;
  }

  @override
  set coreUnits(double g) {
    _grams = g;
  }

  double get grams {
    return coreUnits;
  }

  set grams(double g) {
    coreUnits = g;
  }

  Mass.fromGrams(double g) {
    grams = g;
  }

  double get kilograms {
    return grams / 1000.0;
  }

  set kilograms(double kg) {
    grams = kg * 1000.0;
  }

  Mass.fromKilograms(double kg) {
    kilograms = kg;
  }

  double get pounds {
    return grams / 453.59237;
  }

  set pounds(double lb) {
    grams = lb * 453.59237;
  }

  Mass.fromPounds(double lb) {
    pounds = lb;
  }

  @override
  double getIn(String unit) {
    switch (unit) {
      case "g":
      case "grams":
      case "gram":
        return grams;
      case "kg":
      case "kilograms":
      case "kilogram":
        return kilograms;
      case "lb":
      case "pounds":
      case "pound":
        return pounds;
    }
    throw ArgumentError("unsupported unit");
  }

  @override
  void setIn(double value, String unit) {
    switch (unit) {
      case "g":
      case "grams":
      case "gram":
        {
          grams = value;
          return;
        }
      case "kg":
      case "kilograms":
      case "kilogram":
        {
          kilograms = value;
          return;
        }
      case "lb":
      case "pounds":
      case "pound":
        {
          pounds = value;
          return;
        }
    }
    throw ArgumentError("unsupported unit");
  }

  Mass.fromMap(Map<String, dynamic>? map) {
    setWithMap(map);
  }

  @override
  Mass Function(Map<String, dynamic>? map) get fromMapFactory {
    return Mass.fromMap;
  }

  static final Set<String> _allowedUnits = {
    "g",
    "grams",
    "gram",
    "kg",
    "kilograms",
    "kilogram",
    "lb",
    "pounds",
    "pound"
  };

  @override
  Set<String> get allowedUnits {
    return _allowedUnits;
  }

  @override
  String get coreUnitsIn {
    return "grams";
  }
}

class Velocity extends FromToMap with Measure {
  Velocity();

  late double _metersBySeconds = default_core_units;

  @override
  double get coreUnits {
    return _metersBySeconds;
  }

  @override
  set coreUnits(double mps) {
    _metersBySeconds = mps;
  }

  double get metersBySeconds {
    return coreUnits;
  }

  set metersBySeconds(double mps) {
    coreUnits = mps;
  }

  Velocity.fromMetersBySeconds(double mps) {
    metersBySeconds = mps;
  }

  double get feetBySeconds {
    return metersBySeconds / 0.3048;
  }

  set feetBySeconds(double fps) {
    metersBySeconds = fps * 0.3048;
  }

  Velocity.fromFeetBySeconds(double fps) {
    feetBySeconds = fps;
  }

  double get kilometersByHours {
    return metersBySeconds * (3600.0 / 1000.0);
  }

  set kilometersByHours(double kph) {
    metersBySeconds = kph / (3600.0 / 1000.0);
  }

  Velocity.fromKilometersByHours(double kph) {
    kilometersByHours = kph;
  }

  double get milesByHours {
    return feetBySeconds * (3600.0 / 5280.0);
  }

  set milesByHours(double mph) {
    feetBySeconds = mph / (3600.0 / 5280.0);
  }

  Velocity.fromMilesByHours(double mph) {
    milesByHours = mph;
  }

  @override
  double getIn(String unit) {
    switch (unit) {
      case "m|s":
      case "meters|seconds":
      case "meter|second":
        return metersBySeconds;
      case "ft|s":
      case "feet|seconds":
      case "foot|second":
        return feetBySeconds;
      case "km|h":
      case "kilometers|hours":
      case "kilometer|hour":
        return kilometersByHours;
      case "mi|h":
      case "miles|hours":
      case "mile|hour":
        return milesByHours;
    }
    throw ArgumentError("unsupported unit");
  }

  @override
  void setIn(double value, String unit) {
    switch (unit) {
      case "m|s":
      case "meters|seconds":
      case "meter|second":
        {
          metersBySeconds = value;
          return;
        }
      case "ft|s":
      case "feet|seconds":
      case "foot|second":
        {
          feetBySeconds = value;
          return;
        }
      case "km|h":
      case "kilometers|hours":
      case "kilometer|hour":
        {
          kilometersByHours = value;
          return;
        }
      case "mi|h":
      case "miles|hours":
      case "mile|hour":
        {
          milesByHours = value;
          return;
        }
    }
    throw ArgumentError("unsupported unit");
  }

  Velocity.fromMap(Map<String, dynamic>? map) {
    setWithMap(map);
  }

  @override
  Velocity Function(Map<String, dynamic>? map) get fromMapFactory {
    return Velocity.fromMap;
  }

  static final Set<String> _allowedUnits = {
    "m|s",
    "meters|seconds",
    "meter|second",
    "ft|s",
    "feet|seconds",
    "foot|second",
    "km|h",
    "kilometers|hours",
    "kilometer|hour",
    "mi|h",
    "miles|hours",
    "mile|hour"
  };

  @override
  Set<String> get allowedUnits {
    return _allowedUnits;
  }

  @override
  String get coreUnitsIn {
    return "meters|seconds";
  }
}

class Spin extends FromToMap with Measure {
  Spin();

  late double _radiansBySeconds = default_core_units;

  @override
  double get coreUnits {
    return _radiansBySeconds;
  }

  @override
  set coreUnits(double rps) {
    _radiansBySeconds = rps;
  }

  double get radiansBySeconds {
    return coreUnits;
  }

  set radiansBySeconds(double rps) {
    coreUnits = rps;
  }

  Spin.fromRadiansBySeconds(double rps) {
    radiansBySeconds = rps;
  }

  double get degreesBySeconds {
    return radiansBySeconds * (180.0 / math.pi);
  }

  set degreesBySeconds(double dps) {
    radiansBySeconds = dps / (180.0 / math.pi);
  }

  Spin.fromDegreesBySeconds(double dps) {
    degreesBySeconds = dps;
  }

  double get revolutionsBySeconds {
    return radiansBySeconds / (2.0 * math.pi);
  }

  set revolutionsBySeconds(double rps) {
    radiansBySeconds = rps * (2.0 * math.pi);
  }

  Spin.fromRevolutionsBySeconds(double rps) {
    revolutionsBySeconds = rps;
  }

  double get revolutionsByMinutes {
    return radiansBySeconds * (60.0 / (2.0 * math.pi));
  }

  set revolutionsByMinutes(double rpm) {
    radiansBySeconds = rpm / (60.0 / (2.0 * math.pi));
  }

  Spin.fromRevolutionsByMinutes(double rpm) {
    revolutionsByMinutes = rpm;
  }

  @override
  double getIn(String unit) {
    switch (unit) {
      case "rad|s":
      case "radians|seconds":
      case "radian|second":
        return radiansBySeconds;
      case "deg|s":
      case "degrees|seconds":
      case "degree|second":
        return degreesBySeconds;
      case "rev|s":
      case "revolutions|seconds":
      case "revolution|second":
        return revolutionsBySeconds;
      case "rev|m":
      case "revolutions|minutes":
      case "revolution|minute":
        return revolutionsByMinutes;
    }
    throw ArgumentError("unsupported unit");
  }

  @override
  void setIn(double value, String unit) {
    switch (unit) {
      case "rad|s":
      case "radians|seconds":
      case "radian|second":
        {
          radiansBySeconds = value;
          return;
        }
      case "deg|s":
      case "degrees|seconds":
      case "degree|second":
        {
          degreesBySeconds = value;
          return;
        }
      case "rev|s":
      case "revolutions|seconds":
      case "revolution|second":
        {
          revolutionsBySeconds = value;
          return;
        }
      case "rev|m":
      case "revolutions|minutes":
      case "revolution|minute":
        {
          revolutionsByMinutes = value;
          return;
        }
    }
    throw ArgumentError("unsupported unit");
  }

  Spin.fromMap(Map<String, dynamic>? map) {
    setWithMap(map);
  }

  @override
  Spin Function(Map<String, dynamic>? map) get fromMapFactory {
    return Spin.fromMap;
  }

  static final Set<String> _allowedUnits = {
    "rad|s",
    "radians|seconds",
    "radian|second",
    "deg|s",
    "degrees|seconds",
    "degree|second",
    "rev|s",
    "revolutions|seconds",
    "revolution|second",
    "rev|m",
    "revolutonis|minutes",
    "revolution|minute"
  };

  @override
  Set<String> get allowedUnits {
    return _allowedUnits;
  }

  @override
  String get coreUnitsIn {
    return "radians|seconds";
  }
}
