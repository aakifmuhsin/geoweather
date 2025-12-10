# GeoWeather - Quick Start Guide

## 🚀 Get Running in 3 Minutes

### Step 1: Install Dependencies (1 minute)

```bash
flutter pub get
```

### Step 2: Generate Code (1 minute)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 3: Run the App (1 minute)

```bash
flutter run
```

## 🎉 That's it! No API keys needed!

The app will:
1. Ask for location and notification permissions
2. Fetch your current location
3. Get weather data
4. Show a notification with your weather

**No Google Maps API key required!** We use OpenStreetMap which is completely free and requires no configuration.

## 🎮 Using the App

### Home Screen
- **View Weather**: See current weather for your location
- **Get Current Location**: Button to manually refresh location/weather
- **Start Service**: Begin 30-second background updates
- **Stop Service**: Stop background updates
- **Map Icon** (top right): Open map view

### Map Screen
- **Tap anywhere**: Get weather for that location
- **Current Location button** (top right): Go to your position
- **Back button**: Return to home

### Background Service
Once started:
- Updates every 30 seconds
- Shows notifications with weather
- Runs even when app is closed (Android)
- Stop using the "Stop Service" button

## ⚠️ Important Notes

### First Launch
- Allow location permission when asked
- Allow notification permission when asked
- **If you deny permissions, the app will close automatically** (per requirements)

### Android Users
- Disable battery optimization for the app if background service stops
- Some manufacturers (Xiaomi, OnePlus, Samsung) have aggressive battery savers

### iOS Users
- Background service works only while app is in background
- Service stops if you force-quit the app (iOS limitation)

## 🐛 Troubleshooting

| Problem | Solution |
|---------|----------|
| **App closes immediately** | You denied permissions. Uninstall and reinstall to try again |
| **Map doesn't load** | Check internet connection (map tiles are downloaded from OpenStreetMap) |
| **Location not updating** | Enable location services in device settings |
| **Service stops** | Disable battery optimization for the app |
| **Build error** | Run `flutter clean` then `flutter pub get` |

## 📱 Test the Background Service

1. Launch the app
2. Grant permissions
3. See initial weather notification ✓
4. Press "Start Service"
5. See service notification appear ✓
6. Wait 30 seconds
7. See weather notification update ✓
8. Minimize the app (press home button)
9. Wait 30 seconds
10. See another weather notification ✓
11. **Android only**: Force-close the app from recent apps
12. Wait 30 seconds
13. See weather notification still updating ✓

## 🎯 Features to Try

- ✨ Tap map to get weather for different locations
- 🌍 Real-time location tracking on map
- 🔔 Background notifications with temperature
- 📍 Coordinates displayed in notifications
- ☁️ Weather details (humidity, wind, pressure)

## 💡 Tips

- **Save battery**: Stop the service when not needed
- **Get specific location weather**: Use the map view
- **Check service status**: Look for green indicator on home screen
- **View live updates**: Keep app open to see real-time location on map
- **Map is slow?**: OpenStreetMap tiles load from internet, be patient on first view

## 🗺️ About the Map

We use **OpenStreetMap** instead of Google Maps:
- ✅ 100% free
- ✅ No API key needed
- ✅ No billing or credit card
- ✅ Fully functional with tap and markers
- ✅ Community-maintained map data

The only requirement is an internet connection to load map tiles.

## 📚 Need More Info?

- **Detailed Setup**: See [SETUP_GUIDE.md](SETUP_GUIDE.md)
- **Full Documentation**: See [README.md](README.md)
- **Implementation Details**: See [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)

## 🆘 Still Having Issues?

1. Make sure you're running Flutter 3.5.4+
2. Check that location services are enabled on device
3. Verify you have internet connection (for map tiles and weather API)
4. Try running `flutter clean` and reinstalling
5. Check [SETUP_GUIDE.md](SETUP_GUIDE.md) troubleshooting section

---

**That's all! Enjoy your weather tracking app! 🌤️**

**P.S.** No API keys, no credit cards, no sign-ups required. Just install and run! 🎊
