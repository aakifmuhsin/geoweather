import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// The callback function should always be a top-level function.
@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(WeatherTaskHandler());
}

class WeatherTaskHandler extends TaskHandler {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    // ignore: avoid_print
    print('WeatherTaskHandler: onStart called');

    // Initialize notifications
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _notificationsPlugin.initialize(initSettings);

    // Create notification channel
    const androidChannel = AndroidNotificationChannel(
      'weather_channel',
      'Weather Updates',
      description: 'Shows weather updates with location',
      importance: Importance.high,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  @override
  void onRepeatEvent(DateTime timestamp) async {
    // ignore: avoid_print
    print('WeatherTaskHandler: onRepeatEvent called at $timestamp');

    try {
      // Get current location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final lat = position.latitude;
      final lon = position.longitude;

      // ignore: avoid_print
      print('Location: $lat, $lon');

      // Fetch weather data
      const apiKey = 'd1dd19772a6142d9c438357ee4f10cd5';
      final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final temp = (jsonData['main']['temp'] as num).toDouble();
        final cityName = jsonData['name'] as String? ?? 'Unknown';

        // ignore: avoid_print
        print('Weather: $temp°C in $cityName');

        // Show notification
        await _showWeatherNotification(lat, lon, temp, cityName);

        // Update foreground notification
        FlutterForegroundTask.updateService(
          notificationTitle: 'Weather: ${temp.toStringAsFixed(1)}°C',
          notificationText: 'Lat: ${lat.toStringAsFixed(5)}, Lon: ${lon.toStringAsFixed(5)}',
        );
      } else {
        // ignore: avoid_print
        print('Weather API error: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error in background service: $e');
    }
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    // ignore: avoid_print
    print('WeatherTaskHandler: onDestroy called');
  }

  @override
  void onNotificationButtonPressed(String id) {
    // ignore: avoid_print
    print('Notification button pressed: $id');
  }

  @override
  void onNotificationPressed() {
    // ignore: avoid_print
    print('Notification pressed');
    FlutterForegroundTask.launchApp('/');
  }

  Future<void> _showWeatherNotification(
    double lat,
    double lon,
    double temp,
    String cityName,
  ) async {
    const androidDetails = AndroidNotificationDetails(
      'weather_channel',
      'Weather Updates',
      channelDescription: 'Shows weather updates with location',
      importance: Importance.high,
      priority: Priority.high,
      ongoing: false,
      autoCancel: false,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    final title = 'Weather: ${temp.toStringAsFixed(1)}°C';
    final body = 'Lat: ${lat.toStringAsFixed(5)}, Lon: ${lon.toStringAsFixed(5)}';

    await _notificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }
}
