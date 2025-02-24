// weather_service.dart
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class WeatherService {
  WeatherService() {
    dotenv.load();  // Ensure .env is loaded
  }

  final String apiKey = dotenv.env['APIKEY'] ?? ''; 

  Future<Map<String, dynamic>> fetchWeather(String city) async {  
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return {
          'temperature': data['main']['temp'],
          'description': data['weather'][0]['description']
        };
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
