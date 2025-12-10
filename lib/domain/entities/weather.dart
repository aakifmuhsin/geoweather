class Weather {
  final double temperature;
  final double feelsLike;
  final int humidity;
  final String description;
  final String main;
  final double windSpeed;
  final int pressure;
  final String cityName;
  final double lat;
  final double lon;

  Weather({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.description,
    required this.main,
    required this.windSpeed,
    required this.pressure,
    required this.cityName,
    required this.lat,
    required this.lon,
  });
}
