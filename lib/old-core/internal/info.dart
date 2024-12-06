import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfo {
  static String? appName;
  static String? packageName;
  static String? version;
  static String? buildNumber;
  static String? buildSignature;
  static String? installerStore;

  static PackageInfo? _packageInfo;

  static Future<PackageInfo> getPackageInfo() async {
    return await PackageInfo.fromPlatform();
  }

  static String getPackageName() {
    return packageName ?? 'com.example.app';
  }

  static Future<void> init() async {
    _packageInfo ??= await getPackageInfo();

    appName = _packageInfo?.appName;
    packageName = _packageInfo?.packageName;
    version = _packageInfo?.version;
    buildNumber = _packageInfo?.buildNumber;
    buildSignature = _packageInfo?.buildSignature;
    installerStore = _packageInfo?.installerStore;
  }
}

class PlatformInfo {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  static AndroidDeviceInfo? _androidInfo;
  static IosDeviceInfo? _iosInfo;
  static WebBrowserInfo? _webInfo;
  static WindowsDeviceInfo? _windowsInfo;
  static MacOsDeviceInfo? _macOsInfo;
  static LinuxDeviceInfo? _linuxInfo;

  static bool isAndroid(){
    return defaultTargetPlatform == TargetPlatform.android;
  }

  static Future<AndroidDeviceInfo?> getAndroidInfo() async {
    if(isAndroid()){
      _androidInfo ??= await _deviceInfoPlugin.androidInfo;
    }
    return _androidInfo;
  }

  static bool isIOS(){
    return defaultTargetPlatform == TargetPlatform.iOS;
  }

  static Future<IosDeviceInfo?> getIOSInfo() async {
    if(isIOS()){
      _iosInfo ??= await _deviceInfoPlugin.iosInfo;
    }
    return _iosInfo;
  }

  static bool isWeb(){
    return kIsWeb;
  }

  static Future<WebBrowserInfo?> getWebInfo() async {
    if(isWeb()){
      _webInfo ??= await _deviceInfoPlugin.webBrowserInfo;
    }
    return _webInfo;
  }

  static bool isWindows(){
    return defaultTargetPlatform == TargetPlatform.windows;
  }

  static Future<WindowsDeviceInfo?> getWindowsInfo() async {
    if(isWindows()){
      _windowsInfo ??= await _deviceInfoPlugin.windowsInfo;
    }
    return _windowsInfo;
  }

  static bool isMacOS(){
    return defaultTargetPlatform == TargetPlatform.macOS;
  }

  static Future<MacOsDeviceInfo?> getMacOSInfo() async {
    if(isMacOS()){
      _macOsInfo ??= await _deviceInfoPlugin.macOsInfo;
    }
    return _macOsInfo;
  }

  static bool isLinux(){
    return defaultTargetPlatform == TargetPlatform.linux;
  }

  static Future<LinuxDeviceInfo?> getLinuxInfo() async {
    if(isLinux()){
      _linuxInfo ??= await _deviceInfoPlugin.linuxInfo;
    }
    return _linuxInfo;
  }

  static bool isFuchsia(){
    return defaultTargetPlatform == TargetPlatform.fuchsia;
  }

  static bool isMobile(){
    return isAndroid() || isIOS();
  }

  static bool isDesktop(){
    return isWindows() || isMacOS() || isLinux();
  }

  static Future<dynamic> getDeviceInfo() async {
    if(isAndroid()){
      return getAndroidInfo();
    } else if(isIOS()){
      return getIOSInfo();
    } else if(isWeb()){
      return getWebInfo();
    } else if(isWindows()){
      return getWindowsInfo();
    } else if(isMacOS()){
      return getMacOSInfo();
    } else if(isLinux()){
      return getLinuxInfo();
    } else {
      return null;
    }
  }

  static Future<void> init() async {
    await getDeviceInfo();
  }

  static TargetPlatform? getTargetPlatform() {
    if (isAndroid()) {
      return TargetPlatform.android;
    } else if (isIOS()) {
      return TargetPlatform.iOS;
    } else if (isWeb()) {
      return TargetPlatform.fuchsia;
    } else if (isWindows()) {
      return TargetPlatform.windows;
    } else if (isMacOS()) {
      return TargetPlatform.macOS;
    } else if (isLinux()) {
      return TargetPlatform.linux;
    } else {
      return null;
    }
  }
}

class DeviceInfo {
  static Size getDisplaySizePhysical() {
    return WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
  }

  static Size getDisplaySizeLogical(BuildContext? context) {
    if(context != null){
      return MediaQuery.of(context).size;
    }

    FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
    return view.physicalSize / view.devicePixelRatio;
  }
}