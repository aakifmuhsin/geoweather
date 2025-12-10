import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/remote/weather_remote_data_source.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Weather> getCurrentWeather(double lat, double lon) async {
    try {
      final weatherModel = await remoteDataSource.fetchWeather(lat, lon);
      return weatherModel;
    } catch (e) {
      throw Exception('Failed to get weather data: $e');
    }
  }
}
