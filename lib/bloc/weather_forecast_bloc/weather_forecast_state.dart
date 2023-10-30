part of 'weather_forecast_bloc.dart';

sealed class WeatherForecastState extends Equatable {
  const WeatherForecastState();

  @override
  List<Object> get props => [];
}

final class WeatherForecastInitial extends WeatherForecastState {}

// Weather forecast state
final class WeatherForecastLoading extends WeatherForecastState {}

final class WeatherForecastError extends WeatherForecastState {}

final class WeatherForecastLoaded extends WeatherForecastState {
  final List<WeatherData> weatherForecast;

  const WeatherForecastLoaded(this.weatherForecast);
}
