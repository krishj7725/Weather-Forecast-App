import 'package:intl/intl.dart';

class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final double humidity;
  final double windSpeed;
  final double pressure;
  final List<HourlyForecast> hourlyForecasts;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.hourlyForecasts,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    var list = json['list'] as List;
    var currentWeather = list[0];

    List<HourlyForecast> forecasts = list.take(8).map((item) {
      return HourlyForecast.fromJson(item);
    }).toList();

    return Weather(
      cityName: json['city']['name'],
      temperature: currentWeather['main']['temp'].toDouble(),
      mainCondition: currentWeather['weather'][0]['main'],
      humidity: currentWeather['main']['humidity'].toDouble(),
      windSpeed: currentWeather['wind']['speed'].toDouble(),
      pressure: currentWeather['main']['pressure'].toDouble(),
      hourlyForecasts: forecasts,
    );
  }
}

class HourlyForecast {
  final String time;
  final double temperature;
  final String iconCode;

  HourlyForecast({
    required this.time,
    required this.temperature,
    required this.iconCode,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000);
    String formattedTime = DateFormat.j().format(date);

    return HourlyForecast(
      time: formattedTime,
      temperature: json['main']['temp'].toDouble(),
      iconCode: json['weather'][0]['icon'],
    );
  }
}