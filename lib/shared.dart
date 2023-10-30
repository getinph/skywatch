import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skywatch/theme.dart';

import 'models.dart';

Size screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

launchSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: KbackgroundColor,
      content: Text(message,
          style: const TextStyle(
              decoration: TextDecoration.none,
              fontWeight: FontWeight.bold,
              color: Colors.white))));
}

formatTempText(double temp) {
  return '${temp.toString()}°F';
}

LatLngBound getLatLngBoundFromRadius(double radius, GeoPoint position) {
  double lat = 0.0144927536231884;
  double lon = 0.0181818181818182;
  double distance = radius * 0.000621371;
  double lowerLat = position.latitude - (lat * distance);
  double lowerLng = position.longitude - (lon * distance);
  double greaterLat = position.latitude + (lat * distance);
  double greaterLng = position.longitude + (lon * distance);
  return LatLngBound(
      lowerLat: lowerLat,
      greaterLat: greaterLat,
      lowerLng: lowerLng,
      greaterLng: greaterLng);
}

appConfigInit() async {
  // android needs
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // set portrait orientation
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // Bottom device app bar color
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: KbackgroundColor,
  ));
  // Firebase Init
  await Firebase.initializeApp();
}
