import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/weather_model.dart';

import '../models/weather_icon_data.dart';
import '../service/weather_service.dart';

final TextEditingController cityController = TextEditingController();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


   final imgUrl =
      "https://res.cloudinary.com/dgbz1qem7/image/upload/v1790155042/53d753683e99169c8d3922589bb2d0e9_xafto2.jpg";
  Weather? weather;
  bool isLoading = false;
  String? error;


  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initWeather('Hanoi');
  }

  Future<void> initWeather(String city) async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final result = await WeatherService().getWeather(city);



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


    weather!.city;

    final currentHour = DateTime.now().hour;
    final startIndex = weather!.hourly.indexWhere(
          (hour) => DateTime.parse(hour.time).hour == currentHour,
    );

    final next4Hours = weather!.hourly
        .skip(startIndex)
        .take(4)
        .toList();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.network(imgUrl, fit: BoxFit.cover)),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(

                        children: [
                          const Icon(Icons.location_on, color: Colors.white, size: 18,),
                          const SizedBox(width: 6,),
                          Text(
                            '${weather!.city}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500
                            ),
                          )
                        ],
                      ),

                       SizedBox(height: 10,),
                       //search
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: TextField(
                                controller: cityController,
                                style: const TextStyle(
                                  color: Colors.white
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Nhập thành phố...',
                                  hintStyle: const TextStyle(
                                    color: Colors.white70
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.search_rounded,
                                    color: Colors.white,
                                  ),
                                  filled: true,
                                  fillColor: Colors.black26,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none
                                  )
                                ),

                                //bam enter tren bang phim
                                onSubmitted: (_) {
                                  searchCity();
                                },
                              )),
                          const SizedBox(height: 8,),

                          IconButton(
                            onPressed: searchCity,
                            icon: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),

                       const SizedBox(height: 40,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            Text(
                            '${weather!.temperature}°',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 82,
                                height: 1
                            ),
                          ),

                          //xoay
                          RotatedBox(
                            quarterTurns: 3,
                            child:   Text(
                              translateCondition(weather!.condition),
                              style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2
                              ),
                            ),
                          )
                        ],
                      ),
                    ],

                  )
                ),
                // const SizedBox(height: 0),



                //the thong tin
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //thanh keo
                      Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      const SizedBox(height: 20),

                      //tieu de thong tin
                      const Text(
                        'Thời tiết hôm nay',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54
                        ),
                      ),

                      const SizedBox(height: 24,),

                      //danh sach nhiet do theo gio


                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children:  next4Hours.map((hour) {
                            final iconData = getWeatherIcon(hour.condition);

                              return _HourlyForecastItem(
                                time: formatHour(hour.time),
                                temp: '${hour.temperature.round()}°',
                                icon: iconData.icon ,
                                iconColor: iconData.color,
                              );
                            }).toList(),
                          )
                    ],
                  ),
                )
              ],


            ),

          ),



        ],

      ),

    );
  }


  //search logic
   void searchCity() {
     final city = cityController.text.trim();

     if (city.isEmpty) {
       return;
     }

     initWeather(city);
   }
}


class _HourlyForecastItem extends StatelessWidget {

  final String time;
  final String temp;
  final IconData icon;
  final Color iconColor;

  const _HourlyForecastItem(
  {
    required this.time,
    required this.temp,
    required this.icon,
    required this.iconColor
}
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 32,),
        const SizedBox(height: 8,),
        Text(
          time,
          style: TextStyle(
            color: Colors.black26,
            fontSize: 11,
          ),
        ),

        const SizedBox(height: 6,),

        Text(
          temp,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        )
      ],
    );
  }





}


String formatHour(String time) {
  final dateTime = DateTime.parse(time);
  return DateFormat('hh:mm a').format(dateTime);
}


WeatherIconData getWeatherIcon(String condition) {
  final value = condition.toLowerCase();

  if (value.contains('rain')) {
    return WeatherIconData(
      icon: Icons.grain_rounded,
      color: Colors.blue,
    );
  }

  if (value.contains('cloud')) {
    return WeatherIconData(
      icon: Icons.cloud_rounded,
      color: Colors.grey,
    );
  }

  if (value.contains('sunny') || value.contains('clear')) {
    return WeatherIconData(
      icon: Icons.wb_sunny_rounded,
      color: Colors.amber,
    );
  }

  if (value.contains('haze') || value.contains('smoky')) {
    return WeatherIconData(
      icon: Icons.blur_on_rounded,
      color: Colors.grey,
    );
  }

  return WeatherIconData(
    icon: Icons.cloud_rounded,
    color: Colors.grey,
  );
}

String translateCondition(String condition) {
  final value = condition.toLowerCase();

  if (value.contains('sunny')) {
    return 'Trời nắng';
  }

  if (value.contains('clear')) {
    return 'Trời quang';
  }

  if (value.contains('rain')) {
    return 'Có mưa';
  }

  if (value.contains('cloudy')) {
    return 'Nhiều mây';
  }

  if (value.contains('overcast')) {
    return 'U ám';
  }

  if (value.contains('haze')) {
    return 'Có sương mù';
  }

  if (value.contains('smoky')) {
    return 'Có khói mù';
  }

  return condition;
}

