import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppUtils {
  /// Close the app programmatically
  static Future<void> closeApp() async {
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  /// Show error snackbar
  static void showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  /// Show success snackbar
  static void showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  /// Format temperature with unit
  static String formatTemperature(double temp) {
    return '${temp.toStringAsFixed(1)}°C';
  }

  /// Format coordinates
  static String formatCoordinate(double value, int decimals) {
    return value.toStringAsFixed(decimals);
  }
}
