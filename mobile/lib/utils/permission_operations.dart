// (C) 2019 Haziran Yazılım. All rights reserved.
// Proprietary License.

import 'dart:io' show Platform;
import 'package:permission/permission.dart';

abstract class PermissionOperations {
  static Future<bool> requestPermission(PermissionName permission) async {
    bool granted = false;
    if (Platform.isAndroid) {
      print('shoullda request permisson');
      await Permission.requestPermissions([permission]).then((status) {
        switch (status[0].permissionStatus) {
          case PermissionStatus.allow:
          case PermissionStatus.always:
            granted = true;
            break;
          case PermissionStatus.notAgain:
          case PermissionStatus.notDecided:
          case PermissionStatus.whenInUse:
          case PermissionStatus.deny:
            granted = false;
            break;
          default:
            granted = false;
        }
      });
    } else {
      await Permission.requestSinglePermission(permission).then((status) {
        switch (status) {
          case PermissionStatus.allow:
          case PermissionStatus.always:
            granted = true;
            break;
          case PermissionStatus.notAgain:
          case PermissionStatus.notDecided:
          case PermissionStatus.whenInUse:
          case PermissionStatus.deny:
            granted = false;
            break;
          default:
            granted = false;
        }
      });
    }
    return Future.microtask(() => granted);
  }

  static Future<bool> checkPermission(PermissionName permission) async {
    bool granted = false;
    if (Platform.isAndroid) {
      await Permission.getPermissionsStatus([permission]).then((status) {
        switch (status[0].permissionStatus) {
          case PermissionStatus.allow:
          case PermissionStatus.always:
            granted = true;
            break;
          case PermissionStatus.notAgain:
          case PermissionStatus.notDecided:
          case PermissionStatus.whenInUse:
          case PermissionStatus.deny:
            granted = false;
            break;
          default:
            granted = false;
        }
      });
    } else {
      await Permission.getSinglePermissionStatus(permission).then((status) {
        switch (status) {
          case PermissionStatus.allow:
          case PermissionStatus.always:
            granted = true;
            break;
          case PermissionStatus.notAgain:
          case PermissionStatus.notDecided:
          case PermissionStatus.whenInUse:
          case PermissionStatus.deny:
            granted = false;
            break;
          default:
            granted = false;
        }
      });
    }
    return Future.microtask(() => granted);
  }

  static Future<bool> checkAndRequest(PermissionName permission) async {
    bool granted = await checkPermission(permission) ||
        await requestPermission(permission);
    return await Future.microtask(() => granted);
  }

  static Future<bool> isBlocked(PermissionName permission) async {
    bool blocked = false;
    if (Platform.isAndroid) {
      await Permission.getPermissionsStatus([permission]).then((status) {
        print('status:${status[0].permissionStatus}');
        blocked = status[0].permissionStatus == PermissionStatus.notAgain;
      });
    } else {
      await Permission.getSinglePermissionStatus(permission).then((status) {
        blocked = status == PermissionStatus.notAgain;
      });
    }
    return await Future.microtask(() => blocked);
  }

  static Future<bool> checkAndOpenSettings(PermissionName permission) async {
    if (!await isBlocked(permission)) {
      return await Future.microtask(() => true);
    }
    return Permission.openSettings();
  }
}
