
int toInt(dynamic value, [int defaultValue = 0]) {
  try {
    return int.parse(value.toString());
  } catch (e) {
    return defaultValue;
  }
}

String toString(dynamic value) {
  return value.toString();
}