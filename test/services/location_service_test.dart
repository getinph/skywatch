import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skywatch/services/location.service.dart';

class MockLocationPlugin extends Mock implements Location {}

void main() {
  late LocationService sut;
  late MockLocationPlugin mockLocationPlugin;

  setUp(() {
    mockLocationPlugin = MockLocationPlugin();
    sut = LocationService(mockLocationPlugin);
  });

  final locationData =
      LocationData.fromMap({'latitude': 33.0, "longitude": 43.0});

  arrangeLocationPluginReturnLocation() {
    when(() => mockLocationPlugin.serviceEnabled())
        .thenAnswer((_) async => true);
    when(() => mockLocationPlugin.hasPermission())
        .thenAnswer((_) async => PermissionStatus.granted);
    when(() => mockLocationPlugin.getLocation())
        .thenAnswer((_) async => locationData);
  }

  test("Initial values are correct", () {
    expect(sut.newLocationCompleter, isNull);
  });

  group('getCurrentLocation', () {
    test(
      """Get user location using the Location plugin when service is enabled and permission granted by user
         Check getLocation is called one time when getCurrentLocation is called many times at ones.
      """,
      () async {
        arrangeLocationPluginReturnLocation();
        final Completer<GeoPoint> completer = Completer();
        sut.getCurrentLocation().then((value) => completer.complete(value));
        sut.getCurrentLocation();
        final GeoPoint location = await completer.future;
        expect(location, isA<GeoPoint>());
        verify(() => mockLocationPlugin.getLocation()).called(1);
      },
    );
  });
}
