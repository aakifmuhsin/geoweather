import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../core/constants.dart';
import '../../models/weather_model.dart';

class WeatherRemoteDataSource {
  final http.Client client;

  WeatherRemoteDataSource({required this.client});

  Future<WeatherModel> fetchWeather(double lat, double lon) async {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';

    final url = Uri.parse(
      '${AppConstants.weatherApiBaseUrl}${AppConstants.weatherEndpoint}?lat=$lat&lon=$lon&appid=$apiKey&units=metric',
    );

    try {
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return WeatherModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to fetch weather: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Weather API error: $e');
    }
  }
}
