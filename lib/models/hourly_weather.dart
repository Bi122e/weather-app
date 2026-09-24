class HourlyWeather {

  final String time;
  final double temperature;
  final String condition;


  HourlyWeather(
  {
    required this.time,
    required this.temperature,
    required this.condition
}
  );


  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    return HourlyWeather(time: json['time'], temperature: json['temp_c'], condition: json['condition']['text']);
  }
}