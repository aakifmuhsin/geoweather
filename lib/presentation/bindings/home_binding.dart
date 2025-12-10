import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../data/datasources/remote/weather_remote_data_source.dart';
import '../../data/repositories/weather_repository_impl.dart';
import '../../domain/repositories/weather_repository.dart';
import '../../domain/usecases/get_current_weather.dart';
import '../../services/location_service.dart';
import '../../services/notification_service.dart';
import '../controllers/weather_controller.dart';
import '../controllers/location_controller.dart';
import '../controllers/background_service_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // HTTP Client
    Get.put<http.Client>(http.Client());

    // Services
    Get.put<LocationService>(LocationService());
    Get.put<NotificationService>(NotificationService());

    // Data layer
    Get.put<WeatherRemoteDataSource>(
      WeatherRemoteDataSource(client: Get.find<http.Client>()),
    );

    Get.put<WeatherRepository>(
      WeatherRepositoryImpl(remoteDataSource: Get.find<WeatherRemoteDataSource>()),
    );

    // Domain layer
    Get.put<GetCurrentWeather>(
      GetCurrentWeather(Get.find<WeatherRepository>()),
    );

    // Controllers
    Get.put<WeatherController>(
      WeatherController(
        getCurrentWeatherUseCase: Get.find<GetCurrentWeather>(),
        notificationService: Get.find<NotificationService>(),
      ),
    );

    Get.put<LocationController>(
      LocationController(locationService: Get.find<LocationService>()),
    );

    Get.put<BackgroundServiceController>(
      BackgroundServiceController(),
    );
  }
}
