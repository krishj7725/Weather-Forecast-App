import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const String baseUrl = 'http://api.openweathermap.org/data/2.5/forecast';

  Future<Weather> getWeather(String cityName) async {
    // FIX: Read the key HERE, inside the function.
    // This guarantees the .env file is loaded before we try to use it.
    final String apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';

    // Safety Check
    if (apiKey.isEmpty) {
      throw Exception('API Key is missing! Check your .env file.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}