import 'package:geolocator/geolocator.dart';

class Stringify {
  static String hoursDouble(double hours, {
    String hourSuffix = 'h',
    String minuteSuffix = 'min'
  }) {
    int wholeHours = hours.floor();
    int minutes = ((hours - wholeHours) * 60).round();
    return '$wholeHours$hourSuffix $minutes$minuteSuffix';
  }

  static String stringifyGeolocatorPosition(Position position, {
    int decimalPlaces = 6,
  }) {
    String latString = position.latitude.toStringAsFixed(decimalPlaces);
    String lonString = position.longitude.toStringAsFixed(decimalPlaces);
    String latDir = position.latitude >= 0 ? 'N' : 'S';
    String lonDir = position.longitude >= 0 ? 'E' : 'W';
    return '$latString $latDir, $lonString $lonDir';
  }
}