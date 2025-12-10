import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/weather_controller.dart';
import '../controllers/location_controller.dart';
import '../controllers/background_service_controller.dart';
import 'map_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherController = Get.find<WeatherController>();
    final locationController = Get.find<LocationController>();
    final serviceController = Get.find<BackgroundServiceController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('GeoWeather'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => Get.to(() => const MapPage()),
            tooltip: 'Open Map',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Weather Information Card
            Obx(() {
              if (weatherController.isLoading.value) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }

              if (weatherController.currentWeather.value == null) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text(
                      'No weather data available',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }

              final weather = weatherController.currentWeather.value!;
              return Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        weather.cityName,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${weather.temperature.toStringAsFixed(1)}°C',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        weather.description,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Icon(Icons.water_drop, color: Colors.blue),
                              const SizedBox(height: 4),
                              Text('${weather.humidity}%'),
                              const Text('Humidity', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          Column(
                            children: [
                              const Icon(Icons.air, color: Colors.grey),
                              const SizedBox(height: 4),
                              Text('${weather.windSpeed} m/s'),
                              const Text('Wind', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          Column(
                            children: [
                              const Icon(Icons.compress, color: Colors.orange),
                              const SizedBox(height: 4),
                              Text('${weather.pressure} hPa'),
                              const Text('Pressure', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Lat: ${weather.lat.toStringAsFixed(5)}, Lon: ${weather.lon.toStringAsFixed(5)}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 24),

            // Current Location Button
            Obx(() {
              return ElevatedButton.icon(
                onPressed: locationController.isLoadingLocation.value
                    ? null
                    : () => locationController.getCurrentLocation(),
                icon: locationController.isLoadingLocation.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location),
                label: const Text('Get Current Location Weather'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              );
            }),

            const SizedBox(height: 16),

            // Background Service Controls
            Obx(() {
              final isRunning = serviceController.isServiceRunning.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isRunning ? Colors.green.shade50 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isRunning ? Colors.green : Colors.grey,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isRunning ? Icons.check_circle : Icons.info,
                          color: isRunning ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isRunning
                              ? 'Background service is running'
                              : 'Background service is stopped',
                          style: TextStyle(
                            color: isRunning ? Colors.green.shade900 : Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: isRunning ? null : () => serviceController.startService(),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Service'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: !isRunning ? null : () => serviceController.stopService(),
                    icon: const Icon(Icons.stop),
                    label: const Text('Stop Service'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey,
                    ),
                  ),
                ],
              );
            }),

            const Spacer(),

            // Info Text
            const Card(
              color: Colors.blue,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Background Service Info:',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '• Updates location every 30 seconds\n'
                      '• Fetches weather data automatically\n'
                      '• Shows notifications with updates\n'
                      '• Continues running when app is closed',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
