// weatherPage
import 'package:flutter/material.dart';
import 'package:weather_app/services/weather_service.dart';  // Import the service


class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _controller = TextEditingController();
  // state variables
  String temperatureText = '';
  String descriptionText = '';
  String errorMessage = '';
  bool isLoading = false;

  // WeatherService instance
  final WeatherService _weatherService = WeatherService();

  // Fetch weather data when user submits the city name
  void _fetchWeather(String city) async {
    setState(() {
      isLoading = true;  // Show loading indicator
      errorMessage = '';  // Reset error message
    });

    try {
      var weatherData = await _weatherService.fetchWeather(city);

      setState(() {
        temperatureText = '${weatherData['temperature']}°C';
        descriptionText = weatherData['description'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching data'; 
        descriptionText = '';
        temperatureText = '';
        isLoading = false;
      });
    }
  }

  String getWeatherIcon(String weatherDescription)
  {
    switch(weatherDescription.toLowerCase())
    {
      case 'broken clouds':
      return 'assets/Sunny.png';
      case 'rainy':
      return 'assets/Rainy.png';
      default:
      return 'assets/Sunny.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade100,
        title: Text('Weather App'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(Icons.sunny, size: 150),
            Image.asset(getWeatherIcon(descriptionText)),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter city name',
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (city) {
                  _fetchWeather(city);  // Call the fetch weather method
                },
              ),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : Column(
                    children: [
                      if (errorMessage.isNotEmpty)
                        Text(errorMessage, style: TextStyle(color: Colors.red)),
                      if (temperatureText.isNotEmpty) 
                        Text("Temperature: $temperatureText", style: TextStyle(fontSize: 20)),
                      if (descriptionText.isNotEmpty)
                        Text("Description: $descriptionText", style: TextStyle(fontSize: 20)),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
