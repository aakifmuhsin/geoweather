# GeoWeather 🌦️📍

A Flutter application that runs a background service to fetch the user's current location and display weather information as local notifications. The service continues running even if the app is closed or killed.

## 🎯 Features

- ✅ **Automatic Permission Handling** - Requests location and notification permissions, closes if denied
- ✅ **Instant Weather Updates** - Fetches weather immediately on app launch
- ✅ **Real-time Location Tracking** - Updates location every 30 seconds in background
- ✅ **Interactive Map View** - Tap anywhere to get weather for that location
- ✅ **Background Service** - Continues running when app is closed (Android)
- ✅ **Local Notifications** - Shows weather with coordinates and temperature
- ✅ **Clean Architecture** - Domain, Data, and Presentation layers
- ✅ **GetX State Management** - Reactive and efficient

## 📱 Screenshots

### Home Screen
- Current weather display with temperature, humidity, wind speed, and pressure
- Start/Stop buttons for background service
- Current location weather button
- Service status indicator

### Map View
- OpenStreetMap integration (no API key required!)
- Real-time location marker
- Tap-to-get-weather functionality
- Weather overlay card

## 🚀 Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/geoweather.git
   cd geoweather
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate JSON serialization code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

**That's it! No API keys needed! 🎉**

## 📋 Requirements

- Flutter SDK 3.5.4 or higher
- Dart SDK 3.0.0 or higher
- Android SDK 21+ (for Android)
- iOS 12.0+ (for iOS)
- **No API keys required!** OpenWeatherMap API Key is included for demo

## 🏗️ Architecture

This project follows **Clean Architecture** principles with three main layers:

### Domain Layer
- `entities/` - Core business objects (Weather)
- `repositories/` - Abstract repository interfaces
- `usecases/` - Business logic (GetCurrentWeather)

### Data Layer
- `models/` - Data transfer objects (WeatherModel)
- `datasources/` - Remote data sources (API clients)
- `repositories/` - Repository implementations

### Presentation Layer
- `controllers/` - GetX controllers for state management
- `views/` - UI screens (HomePage, MapPage)
- `bindings/` - Dependency injection setup

### Services Layer
- `notification_service.dart` - Local notifications
- `location_service.dart` - GPS location handling
- `permission_service.dart` - Permission management
- `foreground_service_handler.dart` - Background task execution

## 🔧 Tech Stack

| Technology | Purpose |
|-----------|---------|
| **GetX** | State management & DI |
| **Flutter Map + OpenStreetMap** | Map integration (no API key!) |
| **Geolocator** | Location services |
| **Flutter Local Notifications** | Local notifications |
| **Flutter Foreground Task** | Background service |
| **Permission Handler** | Permission management |
| **HTTP** | API calls |
| **Flutter Dotenv** | Environment variables |
| **JSON Serialization** | Data modeling |

## 📦 Key Packages

```yaml
dependencies:
  get: ^4.6.6
  geolocator: ^14.0.2
  permission_handler: ^12.0.1
  flutter_local_notifications: ^19.5.0
  flutter_map: ^7.0.2              # OpenStreetMap - no API key!
  latlong2: ^0.9.1
  flutter_foreground_task: ^9.1.0
  http: ^1.2.0
  flutter_dotenv: ^6.0.0
  json_annotation: ^4.8.1
  cupertino_icons: ^1.0.8
```

## 🌍 API Integration

### OpenWeatherMap API
- **Endpoint:** `https://api.openweathermap.org/data/2.5/weather`
- **Authentication:** API Key (included for demo)
- **Units:** Metric (Celsius)

**Sample Response:**
```json
{
  "name": "City Name",
  "main": {
    "temp": 28.5,
    "feels_like": 30.2,
    "humidity": 65,
    "pressure": 1013
  },
  "weather": [
    {
      "main": "Clear",
      "description": "clear sky"
    }
  ],
  "wind": {
    "speed": 3.5
  },
  "coord": {
    "lat": 8.195,
    "lon": 77.376
  }
}
```

## ⚙️ Configuration

### Android Permissions (Already Configured)
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_LOCATION" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
```

### iOS Permissions (Already Configured)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs your location to show weather information.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs continuous access to your location.</string>
<key>UIBackgroundModes</key>
<array>
  <string>location</string>
  <string>fetch</string>
</array>
```

## 🎮 How to Use

1. **Launch App** - App requests permissions and fetches initial weather
2. **View Weather** - See current weather with detailed information
3. **Start Service** - Press "Start Service" to enable background updates
4. **Background Updates** - Receive notifications every 30 seconds with weather
5. **Map Feature** - Tap map icon to open map view and select custom locations
6. **Stop Service** - Press "Stop Service" to stop background updates

## ⚠️ Platform-Specific Behavior

### Android
- ✅ Full background service support
- ✅ Continues running when app is killed
- ✅ 30-second interval updates
- ⚠️ May be affected by battery optimization (user must disable)

### iOS
- ✅ Background location updates (limited)
- ⚠️ No continuous background when app is force-quit
- ⚠️ iOS restrictions prevent true background execution
- 💡 Works while app is in background (not terminated)

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| **Permissions denied** | App will close automatically as per requirements |
| **Location not updating** | Check device location services are enabled |
| **Service stops on Android** | Disable battery optimization for the app |
| **iOS background not working** | iOS limitations - works only when app not force-quit |
| **Build errors** | Run `flutter clean && flutter pub get` |
| **Map not loading** | Check internet connection for map tiles |

## 📚 Detailed Documentation

For detailed setup instructions, architecture explanation, and troubleshooting, see [SETUP_GUIDE.md](SETUP_GUIDE.md)

## 🧪 Testing

Run tests:
```bash
flutter test
```

Run with coverage:
```bash
flutter test --coverage
```

## 📝 TODO / Future Enhancements

- [ ] Weather forecast (5-day)
- [ ] Multiple location favorites
- [ ] Weather alerts and warnings
- [ ] Customizable update intervals
- [ ] Dark mode
- [ ] Weather widgets
- [ ] Historical weather data
- [ ] Unit tests and integration tests
- [ ] CI/CD pipeline

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Developer

Built with ❤️ using Flutter

## 🙏 Acknowledgments

- [OpenWeatherMap](https://openweathermap.org/) for weather data API
- [OpenStreetMap](https://www.openstreetmap.org/) for free map tiles
- [Flutter Community](https://flutter.dev/community) for excellent packages and support

---

**Note:** This app was built to demonstrate Flutter capabilities including background services, location tracking, API integration, and Clean Architecture. The OpenWeatherMap API key included is for demonstration purposes only. For production use, obtain your own API key. **No other API keys are required!**
"# geoweather" 
