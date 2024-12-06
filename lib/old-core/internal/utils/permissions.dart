import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:andromeda/old-core/core.dart';

class CorePermissions {
  static Future<bool> shouldRequest(Permission permission) async {
    AndroidDeviceInfo? androidInfo = await PlatformInfo.getAndroidInfo();

    if (androidInfo == null) {
      return false;
    }

    // NOTE: Android 12 (SDK 33) has different storage permission handling
    //       We don't need to request it, because it's granted by default
    if (androidInfo.version.sdkInt >= 33) {
      return permission != Permission.storage;
    }

    return true;
  }

  static Future<bool> isGranted(Permission permission) async {
    if (await shouldRequest(permission)) {
      var status = await permission.status;
      return status.isGranted;
    }
    return true;
  }

  static Future<bool> areGranted(List<Permission> permissions) async {
    for (Permission permission in permissions) {
      if (!(await isGranted(permission))){
        return false;
      }
    }
    return true;
  }

  static Future<List<Permission>> request(List<Permission> permissions) async {
    List<Permission> notGrantedPermissions = [];

    for (Permission permission in permissions) {
      if (await isGranted(permission)) {
        continue;
      }

      PermissionStatus status = await permission.request();

      if (!status.isGranted) {
        notGrantedPermissions.add(permission);
      }
    }

    return notGrantedPermissions;
  }

  // NOTE: this should not be here i think, but whatever
  static Future<void> dialog(BuildContext context, List<Permission> permissions) async {
    Permission? notAllowedPermission = permissions.firstOrNull;

    if (notAllowedPermission != null) {
      if (context.mounted) {
        String? message;

        if (notAllowedPermission == Permission.storage && context.mounted) {
          message = I18n.translate('permissions-need-storage');
        }
        if (notAllowedPermission == Permission.camera && context.mounted) {
          message = I18n.translate('permissions-need-camera');
        }
        if (notAllowedPermission == Permission.microphone && context.mounted) {
          message = I18n.translate('permissions-need-microphone');
        }
        if (notAllowedPermission == Permission.locationWhenInUse && context.mounted) {
          message = I18n.translate('permissions-need-location');
        }

        if (message != null && context.mounted) {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(I18n.translate('permissions-title')),
                content: Text(message!),
                actions: <Widget>[
                  TextButton(
                    child: Text(I18n.translate('permissions-button')),
                    onPressed: () async {
                      openAppSettings();
                      CoreNavigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    }
  }

  // NOTE: this should not be here i think, but whatever
  static Future<void> handle(
    BuildContext context,
    List<Permission> requiredPermissions
  ) async {
    if (await areGranted(requiredPermissions)) {
      return;
    }

    List<Permission> notGrantedPermissions = await request(requiredPermissions);

    if (context.mounted) {
      dialog(context, notGrantedPermissions);
    }
  }
}