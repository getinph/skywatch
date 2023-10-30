import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:skywatch/bloc/current_weather_bloc/current_weather_bloc.dart';
import 'package:skywatch/bloc/weather_forecast_bloc/weather_forecast_bloc.dart';
import 'package:skywatch/clients/open-weather.client.dart';
import 'package:skywatch/pages/home.page.dart';
import 'package:skywatch/services/location.service.dart';
import 'package:skywatch/shared.dart';
import 'package:skywatch/theme.dart';

void main() async {
  await appConfigInit();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final LocationService locationService = LocationService(Location());
  final OpenWeatherClient openWeatherClient = OpenWeatherClient();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme(context),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  CurrentWeatherBloc(locationService, openWeatherClient)),
          BlocProvider(
              create: (context) =>
                  WeatherForecastBloc(locationService, openWeatherClient))
        ],
        child: HomePage(
          locationService: locationService,
          openWeatherClient: openWeatherClient,
        ),
      ),
    );
  }
}
