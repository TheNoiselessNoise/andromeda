import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class SAppConfig extends MapTraversable {
  const SAppConfig([super.data]);

  String get id => get('id');
  String get label => get('label');
  String get content => getString('content');
  String get serverUrl => getString('serverUrl');
  String get apiKey => getString('apiKey');
  IconData get icon => IconData(getInt('icon', 0xe08f), fontFamily: 'MaterialIcons');
  bool get isSecured => getBool('isSecured', false);
  String? get authMethod => getString('authMethod');
  String? get hashedPassword => get('hashedPassword');
  String? get salt => get('salt');
  bool get isCustom => getBool('isCustom', false);
  
  bool get isPasswordProtected => isSecured && authMethod == AppSecureMethod.password && hashedPassword != null && salt != null;
  bool get isBiometricProtected => isSecured && authMethod == AppSecureMethod.biometric;

  Icon? get appiconWidget {
    if (isPasswordProtected) return const Icon(Icons.lock);
    if (isBiometricProtected) return const Icon(Icons.fingerprint);
    return null;
  }

  void setContent(String content) => data['content'] = content;

  Color get appColor {
    if (isPasswordProtected) return Colors.red.withValues(alpha: 0.5);
    if (isBiometricProtected) return Colors.green.withValues(alpha: 0.5);
    return Colors.blue.withValues(alpha: 0.5);
  }

  factory SAppConfig.from({
    required String id,
    required String label,
    required String serverUrl,
    required String apiKey,
    String? content,
    IconData? icon,
    bool? isSecured,
    String? authMethod,
    String? hashedPassword,
    String? salt,
    bool? isCustom,
  }) => SAppConfig({
    'id': id,
    'label': label,
    'content': content,
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
    String? content,
    String? serverUrl,
    String? apiKey,
    IconData? icon,
    bool? isSecured,
    String? authMethod,
    String? hashedPassword,
    String? salt,
    bool? isCustom,
  }) => SAppConfig({
    'id': id,
    'label': label ?? this.label,
    'content': content ?? this.content,
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

class SAppBundle extends MapTraversable {
  static const String _key = 'applications';

  const SAppBundle([super.data]);

  List<SAppConfig> get appList => getList(_key).map((app) => SAppConfig(app)).toList();
  Map<String, SAppConfig> get appMap => Map.fromEntries(appList.map((app) => MapEntry(app.id, app)));

  bool get hasRemoteApps => appList.any((app) => !app.isCustom);
  bool get hasCustomApps => appList.any((app) => app.isCustom);

  List<SAppConfig> get remoteAppList => appList.where((app) => !app.isCustom).toList();
  Map<String, SAppConfig> get remoteAppMap => Map.fromEntries(remoteAppList.map((app) => MapEntry(app.id, app)));

  List<SAppConfig> get customAppList => appList.where((app) => app.isCustom).toList();
  Map<String, SAppConfig> get customAppMap => Map.fromEntries(customAppList.map((app) => MapEntry(app.id, app)));

  SAppBundle removeApplication(SAppConfig app) => SAppBundle({
    _key: appList.where((a) => a.id != app.id).map((a) => a.data).toList(),
  });

  factory SAppBundle.fromAppList(List<SAppConfig> applications) => SAppBundle({
    _key: applications.map((app) => app.data).toList(),
  });

  factory SAppBundle.fromAppMap(Map<String, SAppConfig> applications) => SAppBundle({
    _key: applications.values.map((app) => app.data).toList(),
  });
}