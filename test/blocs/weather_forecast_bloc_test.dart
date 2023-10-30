import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skywatch/bloc/weather_forecast_bloc/weather_forecast_bloc.dart';
import 'package:skywatch/clients/open-weather.client.dart';
import 'package:skywatch/models/weather_data.model.dart';
import 'package:skywatch/services/location.service.dart';

class MockLocationService extends Mock implements LocationService {}

class MockOpenWeatherClient extends Mock implements OpenWeatherClient {}

void main() {
  late MockLocationService mockLocationService;
  late MockOpenWeatherClient mockOpenWeatherClient;

  setUp(() {
    mockLocationService = MockLocationService();
    mockOpenWeatherClient = MockOpenWeatherClient();
  });

  const chicagoLocation = GeoPoint(41, -87);

  final weatherData = WeatherData(
      main: 'main',
      city: 'Puerto Escondido',
      windSpeed: 34,
      timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      temp: 86,
      humidity: 56);

  final weatherForecast = [weatherData, weatherData];

  group('GetWeather', () {
    blocTest(
      'emit [CurrentWeatherLoading, CurrentWeatherLoaded] when successfull',
      build: () {
        when(() => mockLocationService.getCurrentLocation())
            .thenAnswer((_) async => chicagoLocation);
        when(() => mockOpenWeatherClient.getWeatherForecast(chicagoLocation))
            .thenAnswer((_) async => weatherForecast);
        return WeatherForecastBloc(mockLocationService, mockOpenWeatherClient);
      },
      act: (bloc) => bloc.add(const GetWeatherForecast()),
      expect: () =>
          [WeatherForecastLoading(), WeatherForecastLoaded(weatherForecast)],
    );
  });
}
