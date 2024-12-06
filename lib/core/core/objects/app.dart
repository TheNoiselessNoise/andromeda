import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class SAppConfig extends StorableMap {
  const SAppConfig([super.data]);

  String get id => get('id');
  String get label => get('label');
  String get serverUrl => getString('serverUrl');
  String get apiKey => getString('apiKey');
  IconData get icon => IconData(getInt('icon', 0xe08f), fontFamily: 'MaterialIcons');
  bool get isSecured => getBool('isSecured', false);
  String? get authMethod => getString('authMethod');
  String? get hashedPassword => get('hashedPassword');
  String? get salt => get('salt');
  
  // NOTE: flag to determine if the app is local or remote
  // remote: app will get it's data from a server
  // local: app will have it's own designer / builder
  bool get isCustom => getBool('isCustom', false);
  
  bool get isPasswordProtected => isSecured && authMethod == AppSecureMethod.password && hashedPassword != null && salt != null;
  bool get isBiometricProtected => isSecured && authMethod == AppSecureMethod.biometric;

  Icon? get appiconWidget {
    if (isPasswordProtected) return const Icon(Icons.lock);
    if (isBiometricProtected) return const Icon(Icons.fingerprint);
    return null;
  }

  Color get appColor {
    if (isPasswordProtected) return Colors.red.withOpacity(0.5);
    if (isBiometricProtected) return Colors.green.withOpacity(0.5);
    return Colors.blue.withOpacity(0.5);
  }

  factory SAppConfig.from({
    required String id,
    required String label,
    required String serverUrl,
    required String apiKey,
    IconData? icon,
    bool? isSecured,
    String? authMethod,
    String? hashedPassword,
    String? salt,
    bool? isCustom,
  }) => SAppConfig({
    'id': id,
    'label': label,
    'serverUrl': serverUrl,
    'apiKey': apiKey,
    'icon': icon?.codePoint,
    'isSecured': isSecured,
    'authMethod': authMethod,
    'hashedPassword': hashedPassword,
    'salt': salt,
    'isCustom': isCustom,
  });

  SAppConfig copyWith({
    String? label,
    String? serverUrl,
    String? apiKey,
    IconData? icon,
    bool? isSecured,
    String? authMethod,
    String? hashedPassword,
    String? salt,
    bool? isCustom,
  }) => SAppConfig({
    'label': label ?? this.label,
    'serverUrl': serverUrl ?? this.serverUrl,
    'apiKey': apiKey ?? this.apiKey,
    'icon': icon?.codePoint ?? this.icon.codePoint,
    'isSecured': isSecured ?? this.isSecured,
    'authMethod': authMethod ?? this.authMethod,
    'hashedPassword': hashedPassword ?? this.hashedPassword,
    'salt': salt ?? this.salt,
    'isCustom': isCustom ?? this.isCustom,
  });
}

class SAppBundle extends StorableMap {
  const SAppBundle([super.data]);

  List<SAppConfig> get applications => getList('applications').map((app) => SAppConfig(app)).toList();

  bool get hasRemoteApplications => applications.any((app) => !app.isCustom);
  bool get hasCustomApplications => applications.any((app) => app.isCustom);

  List<SAppConfig> get remoteApplications => applications.where((app) => !app.isCustom).toList();
  List<SAppConfig> get customApplications => applications.where((app) => app.isCustom).toList();

  SAppBundle removeApplication(SAppConfig app) => SAppBundle({
    'applications': applications.where((a) => a != app).map((a) => a.data).toList(),
  });

  factory SAppBundle.from({required List<SAppConfig> applications}) => SAppBundle({
    'applications': applications.map((app) => app.data).toList(),
  });
}