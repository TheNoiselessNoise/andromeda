export 'button_style.dart';
export 'casting.dart';
export 'color.dart';
export 'datetime.dart';
export 'from_string.dart';
export 'http.dart';
export 'icon_from_string.dart';
export 'icon.dart';
export 'input_decoration.dart';
export 'iterable.dart';
export 'locale.dart';
export 'string.dart';
export 'text.dart';
export 'text_style.dart';
export 'theme.dart';
export 'widget.dart';

T valueOrDefault<T>(T? value, T defaultValue) {
  if (value is String && value.isEmpty) {
    return defaultValue;
  }

  if (value is List && value.isEmpty) {
    return defaultValue;
  }

  if (value is Map && value.isEmpty) {
    return defaultValue;
  }

  return value ?? defaultValue;
}