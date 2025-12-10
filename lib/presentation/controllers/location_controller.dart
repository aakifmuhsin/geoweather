import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/location_service.dart';
import 'weather_controller.dart';

class LocationController extends GetxController {
  final LocationService locationService;

  LocationController({required this.locationService});

  final Rx<Position?> currentPosition = Rx<Position?>(null);
  final RxBool isLoadingLocation = false.obs;

  double get currentLat => currentPosition.value?.latitude ?? 0.0;
  double get currentLon => currentPosition.value?.longitude ?? 0.0;

  @override
  void onInit() {
    super.onInit();
    _startLocationUpdates();
  }

  Future<void> getCurrentLocation() async {
    try {
      isLoadingLocation.value = true;
      final position = await locationService.getCurrentPosition();
      currentPosition.value = position;

      // Update weather for current location
      final weatherController = Get.find<WeatherController>();
      await weatherController.fetchWeather(position.latitude, position.longitude);
    } catch (e) {
      Get.snackbar('Location Error', 'Failed to get location: $e');
    } finally {
      isLoadingLocation.value = false;
    }
  }

  void _startLocationUpdates() {
    locationService.getPositionStream().listen((position) {
      currentPosition.value = position;
    });
  }
}
