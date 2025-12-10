import 'package:permission_handler/permission_handler.dart';
import '../core/utils/app_utils.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  Future<bool> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      final status = await Permission.notification.request();
      return status.isGranted;
    }
    return true;
  }

  Future<bool> checkAllPermissions() async {
    final locationStatus = await Permission.location.status;
    final notificationStatus = await Permission.notification.status;

    return locationStatus.isGranted && notificationStatus.isGranted;
  }

  Future<bool> requestAllPermissions() async {
    final locationGranted = await requestLocationPermission();
    final notificationGranted = await requestNotificationPermission();

    return locationGranted && notificationGranted;
  }

  Future<void> ensurePermissionsOrExit() async {
    final allGranted = await requestAllPermissions();

    if (!allGranted) {
      AppUtils.showError(
        'Location and Notification permissions are required. App will close.',
      );
      await Future.delayed(const Duration(seconds: 2));
      await AppUtils.closeApp();
    }
  }

  Future<bool> requestBackgroundLocationPermission() async {
    if (await Permission.locationAlways.isDenied) {
      final status = await Permission.locationAlways.request();
      return status.isGranted;
    }
    return await Permission.locationAlways.isGranted;
  }
}
