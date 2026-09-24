import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';

class WeatherService {
  Future<Weather> getWeather(String city) async {
    final url = Uri.parse(
      'https://api.weatherapi.com/v1/forecast.json'
      '?key=d07e5e8a2ddf4c93b3482226261409'
      '&q=$city',
    );

    final response = await http.get(url);

    final data = jsonDecode(response.body);

    return Weather.fromJson(data);
  }
}
