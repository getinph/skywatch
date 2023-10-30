import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skywatch/bloc/weather_forecast_bloc/weather_forecast_bloc.dart';
import 'package:skywatch/shared.dart';

class Forecast extends StatelessWidget {
  const Forecast({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Hourly forecast', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        BlocBuilder<WeatherForecastBloc, WeatherForecastState>(
          builder: (context, state) {
            if (state is WeatherForecastLoaded) {
              return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    ...state.weatherForecast.map((hourForecast) {
                      DateFormat format = DateFormat("EEE, hh:mm a");

                      DateTime forecastDatetime =
                          DateTime.fromMillisecondsSinceEpoch(
                              hourForecast.timestamp * 1000);
                      final String formattedForecast =
                          format.format(forecastDatetime);

                      return Card(
                          child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(formattedForecast,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .merge(
                                        const TextStyle(color: Colors.black))),
                            const SizedBox(height: 5),
                            Text(hourForecast.main,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .merge(
                                        const TextStyle(color: Colors.black))),
                            Text(formatTempText(hourForecast.temp),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .merge(
                                        const TextStyle(color: Colors.black)))
                          ],
                        ),
                      ));
                    }).toList()
                  ]));
            } else {
              return const Padding(
                  padding: EdgeInsets.all(25),
                  child: CircularProgressIndicator());
            }
          },
        )
      ],
    );
  }
}
