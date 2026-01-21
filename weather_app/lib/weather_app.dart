import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/hourly_forecast.dart';
import 'package:weather_app/additional_info.dart';
import 'package:weather_app/secrets.dart';

class WeatherApp extends StatefulWidget {//stateful widgets are mutable
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  late Future<Map<String, dynamic>> weatherFuture;//late is used to tell that the value will be assigned to the variable later on
                                                  //future is used when the data need to be fetched from  the internet ,as it take time so future gives a loading while the task completes in the background 

  @override
  void initState() {//init state is used so that the whole app only build once instead of every time the app is refreshed 
    super.initState();
    weatherFuture = getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {// async it protects the app from freezing 
    String cityname = 'London';

    final res = await http.get(//use to fetch data from the api
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$cityname&appid=$OpenWeatherAPIKey',
      ),
    );

    if (res.statusCode == 200) {//use to overcome the error,if the status is not 200 then give failed 
      return jsonDecode(res.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {//componenets of the app 
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weatherFuture = getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: FutureBuilder(//future builder updates the data when the data is fetched from the api
        future: getCurrentWeather(),
        builder: (context, snapshot) {//snapshot tells the future builder that whether the status is 200 ,data is fetched and if an error occured or not 
                                      //conetxt tells the location of the widget 
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final data = snapshot.data!;// ! is used to tell flutter that the data 100% present ,it is not nullable 
          final currentWeatherdata = data['list'][0];
          final currentTemp = data['list'][0]['main']['temp'];//use to get the data which is required to show 
          final currentSky = data['list'][0]['weather'][0]['main'];
          final humidity = data['list'][0]['main']['humidity'];
          final pressure = data['list'][0]['main']['pressure'];
          final windSpeed = data['list'][0]['wind']['speed'].toDouble();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(//it is use to give a blurry glass effect to the widget
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp K',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'//it means if cureentSky is clouds or rain then give cloud icon otherwise give sunny
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64,
                              ),
                              Text(
                                currentSky,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Weather Forecast',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 10),
                SizedBox(
                  height: 150,
                  child: ListView.builder(//it is use to make a widget which is currently showing up and when we scroll it build the other widgets on demand
                    itemCount: 12,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {//it is use to build the widgets on demand when we scroll accordingly 
                      final hourlyForecast = data['list'][index + 1];
                      final hourlySky =
                          data['list'][index + 1]['weather'][0]['main'];
                      final hourlyTemp = hourlyForecast['main']['temp']
                          .toString();
                      final time = DateTime.parse(hourlyForecast['dt_txt']);
                      return HourlyForecastItem(
                        time: DateFormat.j().format(time),//it is use to format the time in am and pm format
                        icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                            ? Icons.cloud
                            : Icons.sunny,
                        temperature: hourlyTemp,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Additional Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,//it is use to give extra spaces between widgets 
                  children: [
                    AdditionalWidgetItem(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: humidity.toString(),
                    ),
                    AdditionalWidgetItem(
                      icon: Icons.wind_power,
                      label: 'Wind Speed',
                      value: windSpeed.toString(),
                    ),
                    AdditionalWidgetItem(
                      icon: Icons.beach_access_sharp,
                      label: 'Pressure',
                      value: pressure.toString(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
