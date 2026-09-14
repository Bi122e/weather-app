import 'dart:convert';

import 'package:http/http.dart' as http;

class WeatherService {
  Future<void> getWeather(String city) async {
    final url = Uri.parse(
      'https://api.weatherapi.com/v1/current.json'
      '?key=d07e5e8a2ddf4c93b3482226261409'
      '&q=Hanoi',
    );

    final response = await http.get(url);

    final data = jsonDecode(response.body);

    print(data['location']['name']);
    print(data['location']['country']);
     print(data['current']['temp_c']);
    print(data['current']['humidity']);
    print(data['current']['condition']['text']);
  }
}
