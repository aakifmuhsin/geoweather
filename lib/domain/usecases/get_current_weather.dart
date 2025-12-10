import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

class GetCurrentWeather {
  final WeatherRepository repository;

  GetCurrentWeather(this.repository);

  Future<Weather> call(double lat, double lon) async {
    return await repository.getCurrentWeather(lat, lon);
  }
}
