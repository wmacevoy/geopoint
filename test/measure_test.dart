import 'dart:math';
import 'package:test/test.dart';
import 'near.dart';

import 'package:geopoint/src/measure.dart';

void testTemperature() {
  test('temperature defaults', () {
    var temperature = Temperature();
    var eps = 1e-15;
    near(temperature.kelvin, 273.15, eps: eps, relative: true);
    near(temperature.celsius, 0.0, eps: eps, relative: true);
    near(temperature.fahrenheit, 32.0, eps: eps, relative: true);
  });

  test('temperature celsius', () {
    var temperature = Temperature();
    var eps = 1e-15;

    temperature.celsius = 100.0;

    var equiv = Temperature.fromCelsius(temperature.celsius);
    expect(temperature.celsius, equals(equiv.celsius));

    near(temperature.kelvin, 373.15, eps: eps, relative: true);
    near(temperature.celsius, 100.0, eps: eps, relative: true);
    near(temperature.fahrenheit, 212.0, eps: eps, relative: true);

    near(
        temperature.celsius, Temperature.fromKelvin(temperature.kelvin).celsius,
        eps: 0.0);
  });

  test('temperature kelvin', () {
    var temperature = Temperature();

    temperature.kelvin = 298.15;

    var equiv = Temperature.fromKelvin(temperature.kelvin);
    expect(temperature.celsius, equals(equiv.celsius));

    near(temperature.kelvin, 298.15);
    near(temperature.celsius, 25.0);
    near(temperature.fahrenheit, 77.0);
  });

  test('temperature fahrenheit', () {
    var temperature = Temperature();
    var eps = 1e-15;

    var equiv = Temperature.fromFahrenheit(temperature.fahrenheit);
    expect(temperature.celsius, equals(equiv.celsius));

    temperature.fahrenheit = 59.0;
    near(temperature.kelvin, 288.15, eps: eps, relative: true);
    near(temperature.celsius, 15.0, eps: eps, relative: true);
    near(temperature.fahrenheit, 59.0, eps: eps, relative: true);
  });

  test('temperature to map', () {
    var temperature = Temperature.fromCelsius(100.0);
    var map = temperature.toMap();
    near(map['celsius'], 100.0);
  });

  test('temperature from map', () {
    Map<String, dynamic> map = {'k': 200.0};
    var temperature = Temperature.fromMap(map);
    near(temperature.kelvin, 200.0);
  });
}

void testPressure() {
  test('pressure defaults', () {
    var pressure = Pressure();
    var eps = 1e-15;

    near(pressure.pascals, 100000.0, eps: eps, relative: true);
    near(pressure.kilopascals, 100.0, eps: eps, relative: true);
    near(pressure.bar, 1.0, eps: eps, relative: true);
    near(pressure.inHg, 100000.0 / 3386.389, eps: eps, relative: true);
  });

  test('pressure pascals', () {
    var pressure = Pressure();
    var eps = 1e-15;

    pressure.pascals = 200000.0;

    var equiv = Pressure.fromPascals(pressure.pascals);
    expect(pressure.pascals, equals(equiv.pascals));

    near(pressure.pascals, 2.0 * 100000.0, eps: eps, relative: true);
    near(pressure.kilopascals, 2.0 * 100.0, eps: eps, relative: true);
    near(pressure.bar, 2.0 * 1.0, eps: eps, relative: true);
    near(pressure.inHg, 2.0 * 100000.0 / 3386.389, eps: eps, relative: true);
  });

  test('pressure kilopascals', () {
    var pressure = Pressure();
    var eps = 1e-15;

    pressure.kilopascals = 200.0;

    var equiv = Pressure.fromKilopascals(pressure.kilopascals);
    expect(pressure.pascals, equals(equiv.pascals));

    near(pressure.pascals, 2.0 * 100000.0, eps: eps, relative: true);
    near(pressure.kilopascals, 2.0 * 100.0, eps: eps, relative: true);
    near(pressure.bar, 2.0 * 1.0, eps: eps, relative: true);
    near(pressure.inHg, 2.0 * 100000.0 / 3386.389, eps: eps, relative: true);
  });

  test('pressure bar', () {
    var pressure = Pressure();
    var eps = 1e-15;

    pressure.bar = 2.0;

    var equiv = Pressure.fromBar(pressure.bar);
    expect(pressure.pascals, equals(equiv.pascals));

    near(pressure.pascals, 2.0 * 100000.0, eps: eps, relative: true);
    near(pressure.kilopascals, 2.0 * 100.0, eps: eps, relative: true);
    near(pressure.bar, 2.0 * 1.0, eps: eps, relative: true);
    near(pressure.inHg, 2.0 * 100000.0 / 3386.389, eps: eps, relative: true);
  });

  test('pressure inches of mercury', () {
    var pressure = Pressure();
    var eps = 1e-15;

    pressure.inHg = 200000.0 / 3386.389;

    var equiv = Pressure.fromInHg(pressure.inHg);
    expect(pressure.pascals, equals(equiv.pascals));

    near(pressure.pascals, 2.0 * 100000.0, eps: eps, relative: true);
    near(pressure.kilopascals, 2.0 * 100.0, eps: eps, relative: true);
    near(pressure.bar, 2.0 * 1.0, eps: eps, relative: true);
    near(pressure.inHg, 2.0 * 100000.0 / 3386.389, eps: eps, relative: true);
  });

  test('pressure to map', () {
    var pressure = Pressure.fromPascals(100000.0);
    var map = pressure.toMap();
    near(map['pascals'], 100000.0);
  });

  test('pressure from map', () {
    Map<String, dynamic> map = {'bar': 2.0};
    var pressure = Pressure.fromMap(map);
    near(pressure.bar, 2.0);
  });
}

void testDistance() {
  test('distance defaults', () {
    var distance = Distance();
    var eps = 1e-15;

    near(distance.meters, 0.0, eps: eps, relative: true);
    near(distance.centimeters, 0.0, eps: eps, relative: true);
    near(distance.millimeters, 0.0, eps: eps, relative: true);
    near(distance.kilometers, 0.0, eps: eps, relative: true);
    near(distance.inches, 0.0, eps: eps, relative: true);
    near(distance.feet, 0.0, eps: eps, relative: true);
    near(distance.yards, 0.0, eps: eps, relative: true);
    near(distance.miles, 0.0, eps: eps, relative: true);
  });

  test('distance meters', () {
    var distance = Distance();
    var eps = 1e-15;

    distance.meters = 1.0;

    var equiv = Distance.fromMeters(distance.meters);
    expect(distance.meters, equals(equiv.meters));

    near(distance.meters, 1.0, eps: eps, relative: true);
    near(distance.centimeters, 100.0, eps: eps, relative: true);
    near(distance.millimeters, 1000.0, eps: eps, relative: true);
    near(distance.kilometers, 0.001, eps: eps, relative: true);
    near(distance.inches, (100.0 / 2.54), eps: eps, relative: true);
    near(distance.feet, (1.0 / 12.0) * (100.0 / 2.54),
        eps: eps, relative: true);
    near(distance.yards, (1.0 / 36.0) * (100.0 / 2.54),
        eps: eps, relative: true);
    near(distance.miles, (1.0 / (12.0 * 5280.0)) * (100.0 / 2.54),
        eps: eps, relative: true);
  });

  test('distance centimeters', () {
    var distance = Distance();
    var eps = 1e-15;

    distance.centimeters = 100.0;

    var equiv = Distance.fromCentimeters(distance.centimeters);
    expect(distance.meters, equals(equiv.meters));

    near(distance.meters, 1.0, eps: eps, relative: true);
    near(distance.centimeters, 100.0, eps: eps, relative: true);
    near(distance.millimeters, 1000.0, eps: eps, relative: true);
    near(distance.kilometers, 0.001, eps: eps, relative: true);
    near(distance.inches, 100.0 / 2.54, eps: eps, relative: true);
    near(distance.feet, (1.0 / 12.0) * (100.0 / 2.54),
        eps: eps, relative: true);
    near(distance.yards, (1.0 / 36.0) * (100.0 / 2.54),
        eps: eps, relative: true);
    near(distance.miles, (1.0 / (12.0 * 5280.0)) * (100.0 / 2.54),
        eps: eps, relative: true);
  });

  test('distance millimeters', () {
    var distance = Distance();
    var eps = 1e-15;

    distance.millimeters = 1000.0;

    var equiv = Distance.fromMillimeters(distance.millimeters);
    expect(distance.meters, equals(equiv.meters));

    near(distance.meters, 1.0, eps: eps, relative: true);
    near(distance.centimeters, 100.0, eps: eps, relative: true);
    near(distance.millimeters, 1000.0, eps: eps, relative: true);
    near(distance.kilometers, 0.001, eps: eps, relative: true);
    near(distance.inches, 100.0 / 2.54, eps: eps, relative: true);
    near(distance.feet, (1.0 / 12.0) * (100.0 / 2.54),
        eps: eps, relative: true);
    near(distance.yards, (1.0 / 36.0) * (100.0 / 2.54),
        eps: eps, relative: true);
    near(distance.miles, (1.0 / (12.0 * 5280.0)) * (100.0 / 2.54),
        eps: eps, relative: true);
  });

  test('distance kilometers', () {
    var distance = Distance();
    var eps = 1e-15;

    distance.kilometers = 1.0 / 1000.0;

    var equiv = Distance.fromKilometers(distance.kilometers);
    expect(distance.meters, equals(equiv.meters));

    near(distance.meters, 1.0, eps: eps, relative: true);
    near(distance.centimeters, 100.0, eps: eps, relative: true);
    near(distance.millimeters, 1000.0, eps: eps, relative: true);
    near(distance.kilometers, 0.001, eps: eps, relative: true);
    near(distance.inches, 100.0 / 2.54, eps: eps, relative: true);
    near(distance.feet, (1.0 / 12.0) * (100.0 / 2.54),
        eps: eps, relative: true);
    near(distance.yards, (1.0 / 36.0) * (100.0 / 2.54),
        eps: eps, relative: true);
    near(distance.miles, (1.0 / (12.0 * 5280.0)) * (100.0 / 2.54),
        eps: eps, relative: true);
  });

  test('distance inches', () {
    var distance = Distance();
    var eps = 1e-15;

    distance.inches = 12.0;

    var equiv = Distance.fromInches(distance.inches);
    expect(distance.meters, equals(equiv.meters));

    near(distance.meters, 12.0 * 2.54 / 100.0, eps: eps, relative: true);
    near(distance.centimeters, 100.0 * 12.0 * 2.54 / 100.0,
        eps: eps, relative: true);
    near(distance.millimeters, 1000.0 * 12.0 * 2.54 / 100.0,
        eps: eps, relative: true);
    near(distance.kilometers, 0.001 * 12.0 * 2.54 / 100.0,
        eps: eps, relative: true);
    near(distance.inches, 12.0, eps: eps, relative: true);
    near(distance.feet, 1.0, eps: eps, relative: true);
    near(distance.yards, 1.0 / 3.0, eps: eps, relative: true);
    near(distance.miles, 1.0 / 5280.0, eps: eps, relative: true);
  });

  test('distance feet', () {
    var distance = Distance();
    var eps = 1e-15;

    distance.feet = 1.0;

    var equiv = Distance.fromFeet(distance.feet);
    expect(distance.meters, equals(equiv.meters));

    near(distance.meters, 12.0 * 2.54 / 100.0, eps: eps, relative: true);
    near(distance.centimeters, 100.0 * 12.0 * 2.54 / 100.0,
        eps: eps, relative: true);
    near(distance.millimeters, 1000.0 * 12.0 * 2.54 / 100.0,
        eps: eps, relative: true);
    near(distance.kilometers, 0.001 * 12.0 * 2.54 / 100.0,
        eps: eps, relative: true);
    near(distance.inches, 12.0, eps: eps, relative: true);
    near(distance.feet, 1.0, eps: eps, relative: true);
    near(distance.yards, 1.0 / 3.0, eps: eps, relative: true);
    near(distance.miles, 1.0 / 5280.0, eps: eps, relative: true);
  });

  test('distance yards', () {
    var distance = Distance();
    var eps = 1e-15;

    distance.yards = 1.0 / 3.0;

    var equiv = Distance.fromYards(distance.yards);
    expect(distance.meters, equals(equiv.meters));

    near(distance.meters, 12.0 * 2.54 / 100.0, eps: eps, relative: true);
    near(distance.centimeters, 100.0 * 12.0 * 2.54 / 100.0,
        eps: eps, relative: true);
    near(distance.millimeters, 1000.0 * 12.0 * 2.54 / 100.0,
        eps: eps, relative: true);
    near(distance.kilometers, 0.001 * 12.0 * 2.54 / 100.0,
        eps: eps, relative: true);
    near(distance.inches, 12.0, eps: eps, relative: true);
    near(distance.feet, 1.0, eps: eps, relative: true);
    near(distance.yards, 1.0 / 3.0, eps: eps, relative: true);
    near(distance.miles, 1.0 / 5280.0, eps: eps, relative: true);
  });

  test('distance miles', () {
    var distance = Distance();
    var eps = 1e-15;

    distance.miles = 1.0 / 5280.0;

    var equiv = Distance.fromMiles(distance.miles);
    expect(distance.meters, equals(equiv.meters));

    near(distance.meters, 12.0 * 2.54 / 100.0, eps: eps, relative: true);
    near(distance.centimeters, 100.0 * 12.0 * 2.54 / 100.0,
        eps: eps, relative: true);
    near(distance.millimeters, 1000.0 * 12.0 * 2.54 / 100.0,
        eps: eps, relative: true);
    near(distance.kilometers, 0.001 * 12.0 * 2.54 / 100.0,
        eps: eps, relative: true);
    near(distance.inches, 12.0, eps: eps, relative: true);
    near(distance.feet, 1.0, eps: eps, relative: true);
    near(distance.yards, 1.0 / 3.0, eps: eps, relative: true);
    near(distance.miles, 1.0 / 5280.0, eps: eps, relative: true);
  });

  test('distance to map', () {
    var distance = Distance.fromMeters(1000.0);
    var map = distance.toMap();
    near(map['meters'], 1000.0);
  });

  test('distance from map', () {
    Map<String, dynamic> map = {'km': 2.0};
    var distance = Distance.fromMap(map);
    near(distance.kilometers, 2.0);
  });
}

void testDuration() {
  test('duration defaults', () {
    var duration = Duration();
    var eps = 1e-15;
    near(duration.seconds, 0.0, eps: eps, relative: true);
    near(duration.milliseconds, 0.0, eps: eps, relative: true);
    near(duration.microseconds, 0.0, eps: eps, relative: true);
    near(duration.minutes, 0.0, eps: eps, relative: true);
    near(duration.hours, 0.0, eps: eps, relative: true);
  });

  test('duration seconds', () {
    var duration = Duration();
    var eps = 1e-15;

    duration.seconds = 1.0;

    var equiv = Duration.fromSeconds(duration.seconds);
    expect(duration.seconds, equals(equiv.seconds));

    near(duration.seconds, 1.0, eps: eps, relative: true);
    near(duration.milliseconds, 1000.0, eps: eps, relative: true);
    near(duration.microseconds, 1000000.0, eps: eps, relative: true);
    near(duration.minutes, 1.0 / 60.0, eps: eps, relative: true);
    near(duration.hours, 1.0 / 3600.0, eps: eps, relative: true);
  });

  test('duration milliseconds', () {
    var duration = Duration();
    var eps = 1e-15;

    duration.milliseconds = 1000.0;

    var equiv = Duration.fromMilliseconds(duration.milliseconds);
    expect(duration.seconds, equals(equiv.seconds));

    near(duration.seconds, 1.0, eps: eps, relative: true);
    near(duration.milliseconds, 1000.0, eps: eps, relative: true);
    near(duration.microseconds, 1000000.0, eps: eps, relative: true);
    near(duration.minutes, 1.0 / 60.0, eps: eps, relative: true);
    near(duration.hours, 1.0 / 3600.0, eps: eps, relative: true);
  });

  test('duration microseconds', () {
    var duration = Duration();
    var eps = 1e-15;

    duration.microseconds = 1000000.0;

    var equiv = Duration.fromMicroseconds(duration.microseconds);
    expect(duration.seconds, equals(equiv.seconds));

    near(duration.seconds, 1.0, eps: eps, relative: true);
    near(duration.milliseconds, 1000.0, eps: eps, relative: true);
    near(duration.microseconds, 1000000.0, eps: eps, relative: true);
    near(duration.minutes, 1.0 / 60.0, eps: eps, relative: true);
    near(duration.hours, 1.0 / 3600.0, eps: eps, relative: true);
  });

  test('duration minutes', () {
    var duration = Duration();
    var eps = 1e-15;

    duration.minutes = 1.0 / 60.0;

    var equiv = Duration.fromMinutes(duration.minutes);
    expect(duration.seconds, equals(equiv.seconds));

    near(duration.seconds, 1.0, eps: eps, relative: true);
    near(duration.milliseconds, 1000.0, eps: eps, relative: true);
    near(duration.microseconds, 1000000.0, eps: eps, relative: true);
    near(duration.minutes, 1.0 / 60.0, eps: eps, relative: true);
    near(duration.hours, 1.0 / 3600.0, eps: eps, relative: true);
  });

  test('duration hours', () {
    var duration = Duration();
    var eps = 1e-15;

    duration.hours = 1.0 / (60.0 * 60.0);

    var equiv = Duration.fromHours(duration.hours);
    expect(duration.seconds, equals(equiv.seconds));

    near(duration.seconds, 1.0, eps: eps, relative: true);
    near(duration.milliseconds, 1000.0, eps: eps, relative: true);
    near(duration.microseconds, 1000000.0, eps: eps, relative: true);
    near(duration.minutes, 1.0 / 60.0, eps: eps, relative: true);
    near(duration.hours, 1.0 / 3600.0, eps: eps, relative: true);
  });

  test('duration to map', () {
    var duration = Duration.fromSeconds(60.0);
    var map = duration.toMap();
    near(map['seconds'], 60.0);
  });

  test('duration from map', () {
    Map<String, dynamic> map = {'m': 2.0};
    var duration = Duration.fromMap(map);
    near(duration.minutes, 2.0);
  });
}

void testAngle() {
  test('angle defaults', () {
    var angle = Angle();
    var eps = 1e-15;

    near(angle.radians, 0.0, eps: eps, relative: true);
    near(angle.degrees, 0.0, eps: eps, relative: true);
    near(angle.revolutions, 0.0, eps: eps, relative: true);
    near(angle.minutesOfArc, 0.0, eps: eps, relative: true);
  });

  test('angle radians', () {
    var angle = Angle();
    var eps = 1e-15;

    angle.radians = pi;

    var equiv = Angle.fromRadians(angle.radians);
    expect(angle.radians, equals(equiv.radians));

    near(angle.radians, pi, eps: eps, relative: true);
    near(angle.degrees, 180.0, eps: eps, relative: true);
    near(angle.revolutions, 0.5, eps: eps, relative: true);
    near(angle.minutesOfArc, 60.0 * 180.0, eps: eps, relative: true);
  });

  test('angle degrees', () {
    var angle = Angle();
    var eps = 1e-15;

    angle.degrees = 180.0;

    var equiv = Angle.fromDegrees(angle.degrees);
    expect(angle.radians, equals(equiv.radians));

    near(angle.radians, pi, eps: eps, relative: true);
    near(angle.degrees, 180.0, eps: eps, relative: true);
    near(angle.revolutions, 0.5, eps: eps, relative: true);
    near(angle.minutesOfArc, 60.0 * 180.0, eps: eps, relative: true);
  });

  test('angle revolutions', () {
    var angle = Angle();
    var eps = 1e-15;

    angle.revolutions = 0.5;

    var equiv = Angle.fromRevolutions(angle.revolutions);
    expect(angle.radians, equals(equiv.radians));

    near(angle.radians, pi, eps: eps, relative: true);
    near(angle.degrees, 180.0, eps: eps, relative: true);
    near(angle.revolutions, 0.5, eps: eps, relative: true);
    near(angle.minutesOfArc, 60.0 * 180.0, eps: eps, relative: true);
  });

  test('angle minutes of arc', () {
    var angle = Angle();
    var eps = 1e-15;

    angle.minutesOfArc = 180.0 * 60.0;

    var equiv = Angle.fromMinutesOfArc(angle.minutesOfArc);
    expect(angle.radians, equals(equiv.radians));

    near(angle.radians, pi, eps: eps, relative: true);
    near(angle.degrees, 180.0, eps: eps, relative: true);
    near(angle.revolutions, 0.5, eps: eps, relative: true);
    near(angle.minutesOfArc, 60.0 * 180.0, eps: eps, relative: true);
  });

  test('angle to map', () {
    var angle = Angle.fromRadians(pi);
    var map = angle.toMap();
    near(map['radians'], pi);
  });

  test('angle from map', () {
    Map<String, dynamic> map = {'deg': 90.0};
    var angle = Angle.fromMap(map);
    near(angle.degrees, 90.0);
  });
}

void testVelocity() {
  test('velocity defaults', () {
    var velocity = Velocity();
    var eps = 1e-15;

    near(velocity.metersBySeconds, 0.0, eps: eps, relative: true);
    near(velocity.feetBySeconds, 0.0, eps: eps, relative: true);
    near(velocity.kilometersByHours, 0.0, eps: eps, relative: true);
    near(velocity.milesByHours, 0.0, eps: eps, relative: true);
  });

  test('velocity meters by seconds', () {
    var velocity = Velocity();
    var eps = 1e-15;

    var dx = Distance.fromMeters(1.0);
    var dt = Duration.fromSeconds(1.0);

    velocity.metersBySeconds = dx.meters / dt.seconds;

    var equiv = Velocity.fromMetersBySeconds(velocity.metersBySeconds);
    expect(velocity.metersBySeconds, equals(equiv.metersBySeconds));

    near(velocity.metersBySeconds, dx.meters / dt.seconds,
        eps: eps, relative: true);
    near(velocity.feetBySeconds, dx.feet / dt.seconds,
        eps: eps, relative: true);
    near(velocity.kilometersByHours, dx.kilometers / dt.hours,
        eps: eps, relative: true);
    near(velocity.milesByHours, dx.miles / dt.hours, eps: eps, relative: true);
  });

  test('velocity feet by seconds', () {
    var velocity = Velocity();
    var eps = 1e-15;

    var dx = Distance.fromMeters(1.0);
    var dt = Duration.fromSeconds(1.0);

    velocity.feetBySeconds = dx.feet / dt.seconds;

    var equiv = Velocity.fromFeetBySeconds(dx.feet / dt.seconds);
    expect(velocity.metersBySeconds, equals(equiv.metersBySeconds));

    near(velocity.metersBySeconds, dx.meters / dt.seconds,
        eps: eps, relative: true);
    near(velocity.feetBySeconds, dx.feet / dt.seconds,
        eps: eps, relative: true);
    near(velocity.kilometersByHours, dx.kilometers / dt.hours,
        eps: eps, relative: true);
    near(velocity.milesByHours, dx.miles / dt.hours, eps: eps, relative: true);
  });

  test('velocity kilometers by hours', () {
    var velocity = Velocity();
    var eps = 1e-15;

    var dx = Distance.fromMeters(1.0);
    var dt = Duration.fromSeconds(1.0);

    velocity.kilometersByHours = dx.kilometers / dt.hours;

    var equiv = Velocity.fromKilometersByHours(dx.kilometers / dt.hours);
    expect(velocity.metersBySeconds, equals(equiv.metersBySeconds));

    near(velocity.metersBySeconds, dx.meters / dt.seconds,
        eps: eps, relative: true);
    near(velocity.feetBySeconds, dx.feet / dt.seconds,
        eps: eps, relative: true);
    near(velocity.kilometersByHours, dx.kilometers / dt.hours,
        eps: eps, relative: true);
    near(velocity.milesByHours, dx.miles / dt.hours, eps: eps, relative: true);
  });

  test('velocity miles by hours', () {
    var velocity = Velocity();
    var eps = 1e-15;

    var dx = Distance.fromMeters(1.0);
    var dt = Duration.fromSeconds(1.0);

    velocity.milesByHours = dx.miles / dt.hours;

    var equiv = Velocity.fromMilesByHours(dx.miles / dt.hours);
    expect(velocity.metersBySeconds, equals(equiv.metersBySeconds));

    near(velocity.metersBySeconds, dx.meters / dt.seconds,
        eps: eps, relative: true);
    near(velocity.feetBySeconds, dx.feet / dt.seconds,
        eps: eps, relative: true);
    near(velocity.kilometersByHours, dx.kilometers / dt.hours,
        eps: eps, relative: true);
    near(velocity.milesByHours, dx.miles / dt.hours, eps: eps, relative: true);
  });

  test('velocity to map', () {
    var velocity = Velocity.fromMetersBySeconds(15.0);
    var map = velocity.toMap();
    near(map['meters|seconds'], 15.0);
  });

  test('velocity from map', () {
    Map<String, dynamic> map = {'mi|h': 75.0};
    var velocity = Velocity.fromMap(map);
    near(velocity.milesByHours, 75.0);
  });
}

void testMass() {
  test('mass defaults', () {
    var mass = Mass();
    var eps = 1e-15;

    near(mass.grams, 0.0, eps: eps, relative: true);
    near(mass.kilograms, 0.0, eps: eps, relative: true);
    near(mass.pounds, 0.0, eps: eps, relative: true);
  });

  test('mass grams', () {
    var mass = Mass();
    var eps = 1e-15;

    mass.grams = 1000.0;

    var equiv = Mass.fromGrams(mass.grams);
    expect(mass.grams, equals(equiv.grams));

    near(mass.grams, 1000.0, eps: eps, relative: true);
    near(mass.kilograms, 1.0, eps: eps, relative: true);
    near(mass.pounds, 1.0 / 0.45359237, eps: eps, relative: true);
  });

  test('mass kilograms', () {
    var mass = Mass();
    var eps = 1e-15;

    mass.kilograms = 1.0;

    var equiv = Mass.fromKilograms(mass.kilograms);
    expect(mass.grams, equals(equiv.grams));

    near(mass.grams, 1000.0, eps: eps, relative: true);
    near(mass.kilograms, 1.0, eps: eps, relative: true);
    near(mass.pounds, 1.0 / 0.45359237, eps: eps, relative: true);
  });

  test('mass pounds', () {
    var mass = Mass();
    var eps = 1e-15;

    mass.pounds = 1.0 / 0.45359237;

    var equiv = Mass.fromPounds(mass.pounds);
    expect(mass.grams, equals(equiv.grams));

    near(mass.grams, 1000.0, eps: eps, relative: true);
    near(mass.kilograms, 1.0, eps: eps, relative: true);
    near(mass.pounds, 1.0 / 0.45359237, eps: eps, relative: true);
  });

  test('mass to map', () {
    var mass = Mass.fromGrams(100.0);
    var map = mass.toMap();
    near(map['grams'], 100.0);
  });

  test('mass from map', () {
    Map<String, dynamic> map = {'lb': 3.3};
    var mass = Mass.fromMap(map);
    near(mass.pounds, 3.3);
  });
}

void testSpin() {
  test('spin defaults', () {
    var spin = Spin();
    var eps = 1e-15;

    near(spin.radiansBySeconds, 0.0, eps: eps, relative: true);
    near(spin.degreesBySeconds, 0.0, eps: eps, relative: true);
    near(spin.revolutionsBySeconds, 0.0, eps: eps, relative: true);
    near(spin.revolutionsByMinutes, 0.0, eps: eps, relative: true);
  });

  test('spin radians|seconds', () {
    var spin = Spin();
    var eps = 1e-15;

    spin.radiansBySeconds = pi;

    var equiv = Spin.fromRadiansBySeconds(spin.radiansBySeconds);
    expect(spin.radiansBySeconds, equals(equiv.radiansBySeconds));

    near(spin.radiansBySeconds, pi, eps: eps, relative: true);
    near(spin.degreesBySeconds, 180.0, eps: eps, relative: true);
    near(spin.revolutionsBySeconds, 0.5, eps: eps, relative: true);
    near(spin.revolutionsByMinutes, 30.0, eps: eps, relative: true);
  });

  test('spin degrees|seconds', () {
    var spin = Spin();
    var eps = 1e-15;

    spin.degreesBySeconds = 180;
    var equiv = Spin.fromDegreesBySeconds(spin.degreesBySeconds);
    expect(spin.radiansBySeconds, equals(equiv.radiansBySeconds));

    near(spin.radiansBySeconds, pi, eps: eps, relative: true);
    near(spin.degreesBySeconds, 180.0, eps: eps, relative: true);
    near(spin.revolutionsBySeconds, 0.5, eps: eps, relative: true);
    near(spin.revolutionsByMinutes, 30.0, eps: eps, relative: true);
  });

  test('spin revolutions|seconds', () {
    var spin = Spin();
    var eps = 1e-15;

    spin.revolutionsBySeconds = 0.5;
    var equiv = Spin.fromRevolutionsBySeconds(spin.revolutionsBySeconds);
    expect(spin.radiansBySeconds, equals(equiv.radiansBySeconds));

    near(spin.radiansBySeconds, pi, eps: eps, relative: true);
    near(spin.degreesBySeconds, 180.0, eps: eps, relative: true);
    near(spin.revolutionsBySeconds, 0.5, eps: eps, relative: true);
    near(spin.revolutionsByMinutes, 30.0, eps: eps, relative: true);
  });

  test('spin revolutions|minutes', () {
    var spin = Spin();
    var eps = 1e-15;

    spin.revolutionsByMinutes = 30.0;
    var equiv = Spin.fromRevolutionsByMinutes(spin.revolutionsByMinutes);
    expect(spin.radiansBySeconds, equals(equiv.radiansBySeconds));

    near(spin.radiansBySeconds, pi, eps: eps, relative: true);
    near(spin.degreesBySeconds, 180.0, eps: eps, relative: true);
    near(spin.revolutionsBySeconds, 0.5, eps: eps, relative: true);
    near(spin.revolutionsByMinutes, 30.0, eps: eps, relative: true);
  });

  test('spin to map', () {
    var spin = Spin.fromRadiansBySeconds(10 * pi);
    var map = spin.toMap();
    near(map['radians|seconds'], 10 * pi);
  });

  test('spin from map', () {
    Map<String, dynamic> map = {'rev|s': 10000.0};
    var spin = Spin.fromMap(map);
    near(spin.revolutionsBySeconds, 10000.0);
  });
}

void main() {
  testTemperature();
  testDistance();
  testPressure();
  testDuration();
  testAngle();
  testVelocity();
  testMass();
  testSpin();
}
