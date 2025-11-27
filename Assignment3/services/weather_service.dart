import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _apiKey = 'e41aa67470c9b064b66774e3bf80fb6d';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Map<String, dynamic>> getCurrentWeather(String city) async {
    final url = Uri.parse('$_baseUrl/weather?q=$city&appid=$_apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Map<String, dynamic>> getWeatherForecast(String city) async {
    final url = Uri.parse('$_baseUrl/forecast?q=$city&appid=$_apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load forecast data');
    }
  }
}
