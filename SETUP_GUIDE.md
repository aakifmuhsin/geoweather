# GeoWeather Setup Guide

## Complete Flutter Weather App with Background Location Service

This app implements a background service that continuously fetches the user's location and weather information, displaying it via local notifications.

## Features Implemented

✅ **Permission Management**
- Requests location and notification permissions on launch
- Automatically closes app if permissions are denied

✅ **Immediate Weather Fetch**
- Fetches current location and weather on app launch
- Displays notification instantly with weather details

✅ **Interactive Map View**
- Shows user's current location in real-time
- Tap anywhere on map to get weather for that location
- Smooth animations and location tracking

✅ **Background Service**
- Start/Stop buttons for background service control
- Updates location every 30 seconds
- Fetches weather data from OpenWeatherMap API
- Continues running even when app is closed/killed (Android)
- Shows persistent notifications with lat/lon and temperature

✅ **Clean Architecture**
- Domain, Data, and Presentation layers
- GetX for state management
- Separation of concerns with repositories and use cases

## Prerequisites

Before running the app, you need to configure:

### 1. Google Maps API Key

**For Android:**
1. Get a Google Maps API key from [Google Cloud Console](https://console.cloud.google.com/)
2. Open `android/app/src/main/AndroidManifest.xml`
3. Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual API key (line 58)

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_ACTUAL_API_KEY_HERE" />
```

**For iOS:**
1. Open `ios/Runner/AppDelegate.swift` (create if doesn't exist)
2. Add your Google Maps API key:

```swift
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR_ACTUAL_API_KEY_HERE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### 2. OpenWeatherMap API Key

The OpenWeatherMap API key is already configured in the `.env` file:
- API Key: `d1dd19772a6142d9c438357ee4f10cd5`

**Note:** This is a demo key. For production, get your own key from [OpenWeatherMap](https://openweathermap.org/api)

## Installation Steps

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Generate JSON serialization code:**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── core/
│   ├── constants.dart                    # App constants
│   └── utils/
│       └── app_utils.dart                # Utility functions
├── data/
│   ├── datasources/
│   │   └── remote/
│   │       └── weather_remote_data_source.dart
│   ├── models/
│   │   ├── weather_model.dart
│   │   └── weather_model.g.dart         # Generated
│   └── repositories/
│       └── weather_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── weather.dart                  # Domain entity
│   ├── repositories/
│   │   └── weather_repository.dart       # Abstract repository
│   └── usecases/
│       └── get_current_weather.dart      # Use case
├── presentation/
│   ├── bindings/
│   │   └── home_binding.dart             # GetX dependency injection
│   ├── controllers/
│   │   ├── background_service_controller.dart
│   │   ├── location_controller.dart
│   │   └── weather_controller.dart
│   └── views/
│       ├── home_page.dart                # Main UI
│       └── map_page.dart                 # Google Maps UI
├── services/
│   ├── foreground_service_handler.dart   # Background task handler
│   ├── location_service.dart
│   ├── notification_service.dart
│   └── permission_service.dart
└── main.dart                             # App entry point
```

## How It Works

### App Launch Flow
1. App requests location and notification permissions
2. If denied → app closes automatically
3. If granted → fetches current location
4. Fetches weather data for current location
5. Shows notification with weather info immediately

### Background Service Flow
1. User presses "Start Service" button
2. Foreground service initializes with 30-second interval
3. Every 30 seconds:
   - Gets current GPS coordinates
   - Calls OpenWeatherMap API
   - Updates notification with new data (lat, lon, temperature)
4. Service continues until user presses "Stop Service"

### Map Feature
1. Shows real-time current location
2. User can tap anywhere on map
3. App fetches weather for tapped location
4. Displays weather info in overlay card
5. Shows notification with new weather data

## Android-Specific Notes

### Permissions
All required permissions are configured in `AndroidManifest.xml`:
- `ACCESS_FINE_LOCATION` - Precise location
- `ACCESS_COARSE_LOCATION` - Approximate location
- `ACCESS_BACKGROUND_LOCATION` - Background location (Android 10+)
- `FOREGROUND_SERVICE` - Run foreground service
- `FOREGROUND_SERVICE_LOCATION` - Location-based foreground service
- `POST_NOTIFICATIONS` - Show notifications (Android 13+)
- `WAKE_LOCK` - Keep service running
- `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` - Prevent battery optimization

### Foreground Service
Configured in `AndroidManifest.xml` with `foregroundServiceType="location"` to comply with Android requirements.

### Battery Optimization
⚠️ On some devices (Xiaomi, OnePlus, Samsung), the background service may be killed by aggressive battery optimization. Users should:
1. Disable battery optimization for the app
2. Allow auto-start
3. Lock app in recent apps

## iOS-Specific Notes

### Permissions
Configured in `Info.plist`:
- `NSLocationWhenInUseUsageDescription`
- `NSLocationAlwaysAndWhenInUseUsageDescription`
- `NSLocationAlwaysUsageDescription`

### Background Modes
Enabled in `Info.plist`:
- `location` - Background location updates
- `fetch` - Background fetch
- `processing` - Background processing

### iOS Limitations
⚠️ **Important:** iOS does **NOT** support true continuous background execution like Android. The app can:
- Use significant location change monitoring
- Use background fetch (intermittent)
- Work while app is in foreground or background (not killed)

Once the user force-quits the app, iOS will terminate all background activities. This is by design and cannot be circumvented without violating App Store guidelines.

## API Configuration

### Weather API
- **Endpoint:** `https://api.openweathermap.org/data/2.5/weather`
- **Parameters:**
  - `lat` - Latitude
  - `lon` - Longitude
  - `appid` - API key
  - `units=metric` - Celsius temperature

### Example API Call
```
https://api.openweathermap.org/data/2.5/weather?lat=8.195017&lon=77.376383&appid=d1dd19772a6142d9c438357ee4f10cd5&units=metric
```

## Troubleshooting

### Build Errors
If you encounter build errors:
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Location Not Working
- Check permissions in device settings
- Ensure location services are enabled
- Try restarting the app

### Background Service Not Working
**Android:**
- Check battery optimization settings
- Ensure app is not in power-saving mode
- Verify foreground service notification appears

**iOS:**
- Background execution is limited
- Service works only while app is not force-quit
- Check background modes in Info.plist

### Notifications Not Showing
- Check notification permissions
- Verify notification channel is created (Android)
- Check Do Not Disturb settings

## Testing Checklist

- [ ] App requests location permission
- [ ] App requests notification permission
- [ ] App closes if permissions denied
- [ ] Initial weather fetch on app launch
- [ ] Notification shows immediately with weather
- [ ] Map displays current location
- [ ] Tap on map fetches weather
- [ ] Start Service button works
- [ ] Background updates every 30 seconds
- [ ] Notifications show lat/lon/temperature
- [ ] Stop Service button works
- [ ] Service continues after app minimized
- [ ] Service continues after app killed (Android only)

## Production Checklist

Before deploying to production:

1. **API Keys:**
   - [ ] Replace demo OpenWeatherMap API key
   - [ ] Add your own Google Maps API key
   - [ ] Store keys securely (not in version control)

2. **App Identity:**
   - [ ] Change package name in `AndroidManifest.xml`
   - [ ] Update bundle identifier in iOS
   - [ ] Update app name and icon

3. **Permissions:**
   - [ ] Review permission descriptions
   - [ ] Add privacy policy
   - [ ] Explain location usage clearly

4. **Testing:**
   - [ ] Test on multiple Android versions
   - [ ] Test on iOS (with limitations documented)
   - [ ] Test various network conditions
   - [ ] Test permission denial scenarios

## Architecture Benefits

### Clean Architecture
- **Testability:** Each layer can be tested independently
- **Maintainability:** Clear separation of concerns
- **Scalability:** Easy to add new features
- **Flexibility:** Can swap implementations (e.g., different weather APIs)

### GetX State Management
- **Reactive:** Automatic UI updates with Obx
- **Lightweight:** Minimal boilerplate
- **Dependency Injection:** Easy to manage dependencies
- **Navigation:** Simple routing with Get.to()

## License

This project is created for demonstration purposes.

## Support

For issues or questions, please check:
- Flutter documentation: https://flutter.dev
- GetX documentation: https://pub.dev/packages/get
- Google Maps Flutter: https://pub.dev/packages/google_maps_flutter
- OpenWeatherMap API: https://openweathermap.org/api
