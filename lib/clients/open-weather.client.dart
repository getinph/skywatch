import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:skywatch/models/weather_data.model.dart';

class OpenWeatherClient {
  static const String api_key = "cf3706521db55241de3dfece7149d336";

  Future<WeatherData> getCurrentWeather(GeoPoint location) async {
    const String baseUrl = "https://api.openweathermap.org/data/2.5/weather";
    final String latitude = location.latitude.toString();
    final String longitude = location.longitude.toString();
    String url = "$baseUrl?appid=$api_key&lat=$latitude&lon=$longitude";
    final uri = Uri.parse(url);
    Response res = await get(uri);

    if (res.statusCode == 200) {
      WeatherData weatherData = WeatherData.fromJson(jsonDecode(res.body));
      return weatherData;
    } else {
      throw "Unable to retrieve weather data.";
    }
  }

  Future<List<WeatherData>> getWeatherForecast(GeoPoint location) async {
    const String baseUrl = "https://api.openweathermap.org/data/2.5/forecast";
    final String latitude = location.latitude.toString();
    final String longitude = location.longitude.toString();
    String url = "$baseUrl?appid=$api_key&lat=$latitude&lon=$longitude";
    final uri = Uri.parse(url);
    Response res = await get(uri);

    if (res.statusCode == 200) {
      List<WeatherData> weatherDataList = (jsonDecode(res.body)['list'] as List)
          .map((hourForecast) => WeatherData.fromJson(hourForecast))
          .toList();
      return weatherDataList;
    } else {
      throw "Unable to retrieve weather data.";
    }
  }
}
