import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';

import '../service/weather_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Weather? weather;
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    initWeather();
  }

  Future<void> initWeather() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final result = await WeatherService().getWeather('hanoi');

      setState(() {
        weather = result;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weather")),
      body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : error != null
              ? Text(error!)
              : weather == null
              ? const Text("No data")

              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(weather!.city),
              Text(weather!.country),
              Text('${weather!.temperature}°C'),
              Text('${weather!.humidity}%'),
              Text(weather!.condition),
            ],
          )
      ),
    );
  }
}
