import 'package:get/get.dart';
import '../../domain/entities/weather.dart';
import '../../domain/usecases/get_current_weather.dart';
import '../../services/notification_service.dart';
import '../../core/utils/app_utils.dart';

class WeatherController extends GetxController {
  final GetCurrentWeather getCurrentWeatherUseCase;
  final NotificationService notificationService;

  WeatherController({
    required this.getCurrentWeatherUseCase,
    required this.notificationService,
  });

  final Rx<Weather?> currentWeather = Rx<Weather?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  double get temperature => currentWeather.value?.temperature ?? 0.0;
  double get lat => currentWeather.value?.lat ?? 0.0;
  double get lon => currentWeather.value?.lon ?? 0.0;
  String get cityName => currentWeather.value?.cityName ?? 'Unknown';
  String get description => currentWeather.value?.description ?? '';

  Future<void> fetchWeather(double latitude, double longitude) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final weather = await getCurrentWeatherUseCase(latitude, longitude);
      currentWeather.value = weather;

      // Show notification with weather data
      await notificationService.showWeatherNotification(
        lat: latitude,
        lon: longitude,
        temperature: weather.temperature,
        cityName: weather.cityName,
      );
    } catch (e) {
      errorMessage.value = 'Failed to fetch weather: $e';
      AppUtils.showError(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateWeatherForLocation(double latitude, double longitude) async {
    await fetchWeather(latitude, longitude);
  }
}
