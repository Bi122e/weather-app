
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../service/weather_service.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    WeatherService().getWeather('Hanoi');
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather")
      ),
      body: const Center(
        child: Text("Hello Weather12"),
      ),
    );
  }
}