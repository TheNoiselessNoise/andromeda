import 'dart:io';
import 'package:file/memory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:andromeda/old-core/core.dart';

void myMergeMaps(Map<String, dynamic> original, Map<String, dynamic> updates) {
  updates.forEach((key, value) {
    if (value is Map<String, dynamic> && original[key] is Map<String, dynamic>) {
      myMergeMaps(original[key], value);
    } else {
      original[key] = value;
    }
  });
}

enum FormatType {
  decimal,
  percent,
  scientific,
  compact,
  compactLong,
  custom,
}

enum DecimalType {
  automatic,
  periodDecimal,
  commaDecimal,
}

class MimeTypeSpecifier {
  static bool isImage(String mimeType) {
    return mimeType.startsWith('image/');
  }

  static bool isVideo(String mimeType) {
    return mimeType.startsWith('video/');
  }

  static bool isAudio(String mimeType) {
    return mimeType.startsWith('audio/');
  }

  static bool isText(String mimeType) {
    return mimeType.startsWith('text/');
  }

  static bool isApplication(String mimeType) {
    return mimeType.startsWith('application/');
  }
}

class FS {
  static File fileFromBytes(String fileName, Uint8List bytes) {
    final fs = MemoryFileSystem();
    final file = fs.file(fileName);
    file.writeAsBytesSync(bytes);
    return file;
  }
}

String formatNumber(
    num? value, {
      required FormatType formatType,
      DecimalType? decimalType,
      String? currency,
      bool toLowerCase = false,
      String? format,
      String? locale,
    }) {
  if (value == null) {
    return '';
  }
  var formattedValue = '';
  switch (formatType) {
    case FormatType.decimal:
      switch (decimalType!) {
        case DecimalType.automatic:
          formattedValue = NumberFormat.decimalPattern().format(value);
          break;
        case DecimalType.periodDecimal:
          formattedValue = NumberFormat.decimalPattern('en_US').format(value);
          break;
        case DecimalType.commaDecimal:
          formattedValue = NumberFormat.decimalPattern('es_PA').format(value);
          break;
      }
      break;
    case FormatType.percent:
      formattedValue = NumberFormat.percentPattern().format(value);
      break;
    case FormatType.scientific:
      formattedValue = NumberFormat.scientificPattern().format(value);
      if (toLowerCase) {
        formattedValue = formattedValue.toLowerCase();
      }
      break;
    case FormatType.compact:
      formattedValue = NumberFormat.compact().format(value);
      break;
    case FormatType.compactLong:
      formattedValue = NumberFormat.compactLong().format(value);
      break;
    case FormatType.custom:
      final hasLocale = locale != null && locale.isNotEmpty;
      formattedValue =
          NumberFormat(format, hasLocale ? locale : null).format(value);
  }

  if (formattedValue.isEmpty) {
    return value.toString();
  }

  if (currency != null) {
    final currencySymbol = currency.isNotEmpty
        ? currency
        : NumberFormat.simpleCurrency().format(0.0).substring(0, 1);
    formattedValue = '$currencySymbol$formattedValue';
  }

  return formattedValue;
}

void log(Object? object) {
  if (kDebugMode) {
    print(object);
  }
}

Future<Position?> getLastLocation() async {
  try {
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
  } catch (e) {
    return null;
  }
}

void showLocationServiceDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(I18n.translate('location-service-title')),
        content: Text(I18n.translate('location-service-content')),
        actions: <Widget>[
          TextButton(
            child: Text(I18n.translate('location-service-button')),
            onPressed: () {
              Geolocator.openLocationSettings();
              CoreNavigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

String getBase64Image(String filePath) {
  File file = File(filePath);
  List<int> bytes = file.readAsBytesSync();
  return base64Encode(bytes);
}

dynamic mapListSetter(dynamic json, String path, dynamic value) {
  if (json == null) return null;
  if (path.isEmpty) return value;
  String pathPart = path.contains('.') ? path.split('.').first : path;

  if (json is Map) {
    if (json.containsKey(pathPart)) {
      if (path.contains('.')) {
        json[pathPart] = mapListSetter(json[pathPart], path.split('.').sublist(1).join('.'), value);
      } else {
        json[pathPart] = value;
      }
    }
  }

  if (json is List) {
    int pathIndex = int.tryParse(pathPart) ?? -1;
    if (pathIndex < 0) return null;
    if (pathIndex >= json.length) return null;
    if (path.contains('.')) {
      json[pathIndex] = mapListSetter(json[pathIndex], path.split('.').sublist(1).join('.'), value);
    } else {
      json[pathIndex] = value;
    }
  }

  return json;
}

dynamic mapListWalker(dynamic json, String path) {
  if (json == null) return null;
  if (path.isEmpty) return json;
  String pathPart = path.contains('.') ? path.split('.').first : path;

  if (json is Map) {
    if (json.containsKey(pathPart)) {
      if (path.contains('.')) {
        return mapListWalker(json[pathPart], path.split('.').sublist(1).join('.'));
      } else {
        return json[pathPart];
      }
    }
  }

  if (json is List) {
    int pathIndex = int.tryParse(pathPart) ?? -1;
    if (pathIndex < 0) return null;
    if (pathIndex >= json.length) return null;
    if (path.contains('.')) {
      return mapListWalker(json[pathIndex], path.split('.').sublist(1).join('.'));
    } else {
      return json[pathIndex];
    }
  }

  return null;
}

dynamic loadJsonAndGet(String jsonObject, [String? path]) {
  dynamic json = jsonDecode(jsonObject);
  if (path != null) {
    return mapListWalker(json, path);
  }
  return json;
}

bool isStringEmpty(String? string) {
  return string == null || string.isEmpty;
}