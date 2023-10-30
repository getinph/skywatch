import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:skywatch/clients/open-weather.client.dart';
import 'package:skywatch/global.dart';
import 'package:skywatch/models/weather_data.model.dart';
import 'package:skywatch/services/location.service.dart';

part 'current_weather_event.dart';
part 'current_weather_state.dart';

class CurrentWeatherBloc
    extends Bloc<CurrentWeatherEvent, CurrentWeatherState> {
  final LocationService locationService;
  final OpenWeatherClient openWeatherClient;
  CurrentWeatherBloc(this.locationService, this.openWeatherClient)
      : super(CurrentWeatherInitial()) {
    on<CurrentWeatherEvent>((event, emit) async {
      if (event is GetCurrentWeather) {
        emit(CurrentWeatherLoading());
        final GeoPoint? location =
            Global.location = await locationService.getCurrentLocation();
        if (location != null) {
          await openWeatherClient.getCurrentWeather(location).then(
              (currentWeather) => emit(CurrentWeatherLoaded(currentWeather)),
              onError: (error) => emit(CurrentWeatherError()));
        } else {
          emit(CurrentWeatherError());
        }
      }
    });
  }
}
