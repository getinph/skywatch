import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:skywatch/clients/open-weather.client.dart';
import 'package:skywatch/global.dart';
import 'package:skywatch/models/weather_data.model.dart';
import 'package:skywatch/services/location.service.dart';

part 'weather_forecast_event.dart';
part 'weather_forecast_state.dart';

class WeatherForecastBloc
    extends Bloc<WeatherForecastEvent, WeatherForecastState> {
  final LocationService locationService;
  final OpenWeatherClient openWeatherClient;
  WeatherForecastBloc(this.locationService, this.openWeatherClient)
      : super(WeatherForecastInitial()) {
    on<WeatherForecastEvent>((event, emit) async {
      if (event is GetWeatherForecast) {
        emit(WeatherForecastLoading());
        final GeoPoint? location =
            Global.location = await locationService.getCurrentLocation();
        if (location != null) {
          await openWeatherClient.getWeatherForecast(location).then(
              (currentWeather) => emit(WeatherForecastLoaded(currentWeather)),
              onError: (error) => emit(WeatherForecastError()));
        } else {
          emit(WeatherForecastError());
        }
      }
    });
  }
}
