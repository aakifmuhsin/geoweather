import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/weather_controller.dart';
import '../controllers/location_controller.dart';
import '../../core/constants.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  LatLng? _selectedLocation;
  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _setupInitialMarker();
  }

  void _setupInitialMarker() {
    final locationController = Get.find<LocationController>();
    if (locationController.currentPosition.value != null) {
      final pos = locationController.currentPosition.value!;
      _selectedLocation = LatLng(pos.latitude, pos.longitude);
      _markers.add(
        Marker(
          point: _selectedLocation!,
          width: 40,
          height: 40,
          child: const Icon(
            Icons.location_pin,
            color: Colors.blue,
            size: 40,
          ),
        ),
      );
      setState(() {});
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng location) {
    setState(() {
      _selectedLocation = location;
      _markers.clear();
      _markers.add(
        Marker(
          point: location,
          width: 40,
          height: 40,
          child: const Icon(
            Icons.location_pin,
            color: Colors.red,
            size: 40,
          ),
        ),
      );
    });

    // Fetch weather for selected location
    final weatherController = Get.find<WeatherController>();
    weatherController.updateWeatherForLocation(location.latitude, location.longitude);
  }

  void _goToCurrentLocation() {
    final locationController = Get.find<LocationController>();
    if (locationController.currentPosition.value != null) {
      final pos = locationController.currentPosition.value!;
      final latLng = LatLng(pos.latitude, pos.longitude);
      _mapController.move(latLng, AppConstants.defaultZoom);

      // Update marker and fetch weather
      setState(() {
        _selectedLocation = latLng;
        _markers.clear();
        _markers.add(
          Marker(
            point: latLng,
            width: 40,
            height: 40,
            child: const Icon(
              Icons.location_pin,
              color: Colors.blue,
              size: 40,
            ),
          ),
        );
      });

      final weatherController = Get.find<WeatherController>();
      weatherController.updateWeatherForLocation(latLng.latitude, latLng.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationController = Get.find<LocationController>();
    final weatherController = Get.find<WeatherController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _goToCurrentLocation,
            tooltip: 'Go to Current Location',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Flutter Map with OpenStreetMap
          Obx(() {
            final currentPos = locationController.currentPosition.value;
            final initialPosition = currentPos != null
                ? LatLng(currentPos.latitude, currentPos.longitude)
                : const LatLng(
                    AppConstants.defaultLatitude,
                    AppConstants.defaultLongitude,
                  );

            return FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: initialPosition,
                initialZoom: AppConstants.defaultZoom,
                onTap: _onMapTap,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
              ),
              children: [
                // OpenStreetMap tile layer - NO API KEY NEEDED!
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.geoweather',
                  maxZoom: 19,
                ),
                // Marker layer for current/selected location
                MarkerLayer(
                  markers: _markers,
                ),
              ],
            );
          }),

          // Weather Info Overlay
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Obx(() {
              if (weatherController.isLoading.value) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 12),
                        Text('Loading weather...'),
                      ],
                    ),
                  ),
                );
              }

              if (weatherController.currentWeather.value == null) {
                return const SizedBox.shrink();
              }

              final weather = weatherController.currentWeather.value!;
              return Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            weather.cityName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${weather.temperature.toStringAsFixed(1)}°C',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        weather.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.water_drop, size: 16, color: Colors.blue),
                          const SizedBox(width: 4),
                          Text('${weather.humidity}%'),
                          const SizedBox(width: 16),
                          const Icon(Icons.air, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text('${weather.windSpeed} m/s'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Lat: ${weather.lat.toStringAsFixed(4)}, Lon: ${weather.lon.toStringAsFixed(4)}',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),

          // Instructions
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Card(
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: const [
                    Icon(Icons.touch_app, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tap anywhere on the map to get weather for that location',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
