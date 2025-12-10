// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherModel _$WeatherModelFromJson(Map<String, dynamic> json) => WeatherModel(
      temperature: (json['temperature'] as num).toDouble(),
      feelsLike: (json['feelsLike'] as num).toDouble(),
      humidity: (json['humidity'] as num).toInt(),
      description: json['description'] as String,
      main: json['main'] as String,
      windSpeed: (json['windSpeed'] as num).toDouble(),
      pressure: (json['pressure'] as num).toInt(),
      cityName: json['cityName'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    );

Map<String, dynamic> _$WeatherModelToJson(WeatherModel instance) =>
    <String, dynamic>{
      'temperature': instance.temperature,
      'feelsLike': instance.feelsLike,
      'humidity': instance.humidity,
      'description': instance.description,
      'main': instance.main,
      'windSpeed': instance.windSpeed,
      'pressure': instance.pressure,
      'cityName': instance.cityName,
      'lat': instance.lat,
      'lon': instance.lon,
    };
