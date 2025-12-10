import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../core/constants.dart';
import '../core/utils/app_utils.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(initSettings);

    // Create notification channel for Android
    const androidChannel = AndroidNotificationChannel(
      AppConstants.weatherChannelId,
      AppConstants.weatherChannelName,
      description: AppConstants.weatherChannelDescription,
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  Future<void> showWeatherNotification({
    required double lat,
    required double lon,
    required double temperature,
    String? cityName,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      AppConstants.weatherChannelId,
      AppConstants.weatherChannelName,
      channelDescription: AppConstants.weatherChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      ongoing: false,
      autoCancel: false,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final title = cityName != null
        ? 'Weather: ${AppUtils.formatTemperature(temperature)}'
        : 'GeoWeather: ${AppUtils.formatTemperature(temperature)}';

    final body = 'Lat: ${AppUtils.formatCoordinate(lat, 5)}, Lon: ${AppUtils.formatCoordinate(lon, 5)}';

    await _plugin.show(
      AppConstants.weatherNotificationId,
      title,
      body,
      notificationDetails,
    );
  }

  Future<void> showForegroundServiceNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      AppConstants.weatherChannelId,
      AppConstants.weatherChannelName,
      channelDescription: AppConstants.weatherChannelDescription,
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      playSound: false,
      icon: '@mipmap/ic_launcher',
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _plugin.show(
      AppConstants.foregroundNotificationId,
      title,
      body,
      notificationDetails,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }
}
