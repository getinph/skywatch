import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:skywatch/bloc/current_weather_bloc/current_weather_bloc.dart';
import 'package:skywatch/bloc/weather_forecast_bloc/weather_forecast_bloc.dart';
import 'package:skywatch/clients/open-weather.client.dart';
import 'package:skywatch/components/current_weather.component.dart';
import 'package:skywatch/components/forecast.component.dart';
import 'package:skywatch/components/share_story_button.component.dart';
import 'package:skywatch/layers/weather_story_player.layer.dart';
import 'package:skywatch/services/location.service.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {super.key,
      required this.locationService,
      required this.openWeatherClient});

  final LocationService locationService;
  final OpenWeatherClient openWeatherClient;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    FirebaseAuth.instance.signInAnonymously();
    loadWeather();
    super.initState();
  }

  loadWeather() async {
    if (mounted) {
      BlocProvider.of<CurrentWeatherBloc>(context)
          .add(const GetCurrentWeather());
    }
    if (mounted) {
      BlocProvider.of<WeatherForecastBloc>(context)
          .add(const GetWeatherForecast());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title:
            Text("SKYWATCH", style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: BlocBuilder<CurrentWeatherBloc, CurrentWeatherState>(
          builder: (context, state) {
        if (state is CurrentWeatherLoaded) {
          return Stack(key: const Key('home_page_stack'), children: [
            const Positioned.fill(
              child: WeatherStoryPlayer(),
            ),
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        CurrentWeather(
                            currentWeather: state.currentWeather,
                            reloadWeather: () => loadWeather()),
                        const SizedBox(
                          height: 30,
                        ),
                        const ShareStoryButton()
                      ],
                    ),
                    const Forecast(),
                  ]),
            )
          ]);
        } else {
          return Center(child: Lottie.asset('assets/lotties/sun.json'));
        }
      }),
    );
  }
}
