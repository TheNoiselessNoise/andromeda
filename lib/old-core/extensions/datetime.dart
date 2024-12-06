extension DateTimeExtensions on DateTime {
  String stringDate() {
    return toIso8601String().split('T').first;
  }

  String stringTime() {
    return toIso8601String().split('T').last.split('.').first;
  }

  String stringDateTime() {
    return '${stringDate()} ${stringTime()}';
  }
}