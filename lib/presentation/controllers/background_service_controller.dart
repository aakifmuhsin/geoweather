import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import '../../services/foreground_service_handler.dart';
import '../../core/utils/app_utils.dart';

class BackgroundServiceController extends GetxController {
  final RxBool isServiceRunning = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkServiceStatus();
  }

  Future<void> _checkServiceStatus() async {
    isServiceRunning.value = await FlutterForegroundTask.isRunningService;
  }

  Future<void> startService() async {
    try {
      // Check if service is already running
      if (isServiceRunning.value) {
        AppUtils.showError('Service is already running');
        return;
      }

      // Initialize foreground task
      await _initForegroundTask();

      // Start the foreground service
      await FlutterForegroundTask.startService(
        serviceId: 256,
        notificationTitle: 'GeoWeather Service',
        notificationText: 'Fetching location and weather updates',
        callback: startCallback,
      );

      isServiceRunning.value = true;
      AppUtils.showSuccess('Background service started');
    } catch (e) {
      AppUtils.showError('Error starting service: $e');
    }
  }

  Future<void> stopService() async {
    try {
      if (!isServiceRunning.value) {
        AppUtils.showError('Service is not running');
        return;
      }

      await FlutterForegroundTask.stopService();
      isServiceRunning.value = false;
      AppUtils.showSuccess('Background service stopped');
    } catch (e) {
      AppUtils.showError('Error stopping service: $e');
    }
  }

  Future<void> _initForegroundTask() async {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'weather_foreground_service',
        channelName: 'Weather Foreground Service',
        channelDescription: 'This notification appears when the weather service is running in the background.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(30000), // 30 seconds
        autoRunOnBoot: false,
        autoRunOnMyPackageReplaced: false,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }
}
