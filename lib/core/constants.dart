class AppConstants {
  // Notification constants
  static const String weatherChannelId = 'weather_channel';
  static const String weatherChannelName = 'Weather Updates';
  static const String weatherChannelDescription = 'Shows weather updates with location';
  static const int weatherNotificationId = 0;
  static const int foregroundNotificationId = 1;

  // Background service constants
  static const Duration backgroundFetchInterval = Duration(seconds: 30);

  // Weather API
  static const String weatherApiBaseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String weatherEndpoint = '/weather';

  // Default map position
  static const double defaultLatitude = 8.195016562680948;
  static const double defaultLongitude = 77.37638344987191;
  static const double defaultZoom = 14.0;
}
