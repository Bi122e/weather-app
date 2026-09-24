import 'package:weather_app/models/hourly_weather.dart';

class Weather {

  final String city;
  final double  temperature;
  final int  humidity;
  final String country;
  final String condition;
  final List<HourlyWeather> hourly;

  Weather({
    required this.country,
    required this.city,
    required this.temperature,
    required this.humidity,
    required this.condition,
    required this.hourly,
  });


  factory Weather.fromJson(Map<String, dynamic> data) {
    final hourlyData = data['forecast']['forecastday'][0]['hour'];

    return Weather(
      city: data['location']['name'],
      country: data['location']['country'],
      temperature: data['current']['temp_c'],
      humidity: data['current']['humidity'],
      condition: data['current']['condition']['text'],

      hourly: hourlyData
        .map<HourlyWeather>(
          (item) => HourlyWeather.fromJson(item),
      )
        .toList(),
    );
  }
}