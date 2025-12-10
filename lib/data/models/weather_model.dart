import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/weather.dart';

part 'weather_model.g.dart';

@JsonSerializable()
class WeatherModel extends Weather {
  WeatherModel({
    required super.temperature,
    required super.feelsLike,
    required super.humidity,
    required super.description,
    required super.main,
    required super.windSpeed,
    required super.pressure,
    required super.cityName,
    required super.lat,
    required super.lon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>;
    final weather = (json['weather'] as List)[0] as Map<String, dynamic>;
    final wind = json['wind'] as Map<String, dynamic>;
    final coord = json['coord'] as Map<String, dynamic>;

    return WeatherModel(
      temperature: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      humidity: main['humidity'] as int,
      description: weather['description'] as String,
      main: weather['main'] as String,
      windSpeed: (wind['speed'] as num).toDouble(),
      pressure: main['pressure'] as int,
      cityName: json['name'] as String? ?? 'Unknown',
      lat: (coord['lat'] as num).toDouble(),
      lon: (coord['lon'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => _$WeatherModelToJson(this);
}
