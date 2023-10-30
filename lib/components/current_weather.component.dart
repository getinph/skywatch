import 'package:flutter/material.dart';
import 'package:skywatch/components/metric.component.dart';
import 'package:skywatch/models/weather_data.model.dart';
import 'package:skywatch/shared.dart';

class CurrentWeather extends StatelessWidget {
  const CurrentWeather(
      {super.key, required this.currentWeather, required this.reloadWeather});

  final WeatherData currentWeather;
  final Function() reloadWeather;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(currentWeather.city!,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .merge(const TextStyle(fontWeight: FontWeight.bold))),
          const SizedBox(
            width: 5,
          ),
          IconButton(
              onPressed: () => reloadWeather(),
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
                size: 30,
              ))
        ],
      ),
      const SizedBox(height: 10),
      Text(currentWeather.main,
          style: Theme.of(context).textTheme.displayMedium),
      const SizedBox(height: 10),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Metric(
            iconData: Icons.water_drop_rounded,
            value: currentWeather.humidity.toString(),
            unit: '%'),
        const SizedBox(
          height: 30,
          child: VerticalDivider(
            thickness: 3,
          ),
        ),
        Metric(
            iconData: Icons.thermostat,
            value: formatTempText(currentWeather.temp),
            unit: '°F'),
        const SizedBox(
          height: 30,
          child: VerticalDivider(
            thickness: 3,
          ),
        ),
        Metric(
            iconData: Icons.air,
            value: currentWeather.windSpeed.toString(),
            unit: 'mph')
      ]),
    ]);
  }
}
