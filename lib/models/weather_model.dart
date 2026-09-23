class Weather {

  final String city;
  final double  temperature;
  final int  humidity;
  final String country;
  final String condition;

  Weather({
    required this.country,
    required this.city,
    required this.temperature,
    required this.humidity,
    required this.condition
  });


  factory Weather.fromJson(Map<String, dynamic> data) {
    return Weather(
      city: data['location']['name'],
      country: data['location']['country'],
      temperature: data['current']['temp_c'],
      humidity: data['current']['humidity'],
      condition: data['current']['condition']['text'],
    );
  }
}