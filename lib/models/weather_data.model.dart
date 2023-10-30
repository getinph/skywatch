import 'package:equatable/equatable.dart';

class WeatherData extends Equatable {
  String main;
  String? city;
  double windSpeed;
  double temp;
  int humidity;
  int timestamp;

  WeatherData({
    required this.main,
    required this.city,
    required this.windSpeed,
    required this.timestamp,
    required this.temp,
    required this.humidity,
  });

  factory WeatherData.fromJson(json) {
    return WeatherData(
        main: json['weather'][0]['main'],
        city: json['name'],
        windSpeed: json['wind']['speed'].toDouble(),
        timestamp: json['dt'],
        temp: json['main']['temp'],
        humidity: json['main']['humidity']);
  }

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
