import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class LocationService {
  final Location locationPlugin;
  Completer<GeoPoint>? newLocationCompleter;

  LocationService(this.locationPlugin);

  Future<GeoPoint?> getCurrentLocation() async {
    if (newLocationCompleter != null) {
      return newLocationCompleter!.future;
    } else {
      newLocationCompleter = Completer<GeoPoint>();
      bool isLocationServiceEnabled = await locationPlugin.serviceEnabled();
      if (!isLocationServiceEnabled) {
        bool isServiceActivated = await locationPlugin.requestService();
        if (isServiceActivated == false) {
          return null;
        }
      }

      PermissionStatus permissionStatus = await locationPlugin.hasPermission();
      if (permissionStatus == PermissionStatus.denied) {
        permissionStatus = await locationPlugin.requestPermission();
        if (permissionStatus != PermissionStatus.granted) {
          return null;
        }
      }

      LocationData locationData = await locationPlugin.getLocation();
      if (locationData.latitude == null || locationData.longitude == null) {
        return null;
      }
      final newLocation =
          GeoPoint(locationData.latitude!, locationData.longitude!);
      newLocationCompleter!.complete(newLocation);
      newLocationCompleter = null;
      return newLocation;
    }
  }
}
