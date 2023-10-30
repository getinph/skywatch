part of 'current_weather_bloc.dart';

sealed class CurrentWeatherState extends Equatable {
  const CurrentWeatherState();

  @override
  List<Object> get props => [];
}

final class CurrentWeatherInitial extends CurrentWeatherState {}

final class CurrentWeatherLoading extends CurrentWeatherState {}

final class CurrentWeatherError extends CurrentWeatherState {}

final class CurrentWeatherLoaded extends CurrentWeatherState {
  final WeatherData currentWeather;

  const CurrentWeatherLoaded(this.currentWeather);
}
