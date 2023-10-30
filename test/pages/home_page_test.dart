// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skywatch/bloc/current_weather_bloc/current_weather_bloc.dart';
import 'package:skywatch/bloc/weather_forecast_bloc/weather_forecast_bloc.dart';
import 'package:skywatch/clients/open-weather.client.dart';
import 'package:skywatch/models/weather_data.model.dart';
import 'package:skywatch/pages/home.page.dart';
import 'package:skywatch/services/location.service.dart';

class MockCurrentWeatherBloc
    extends MockBloc<CurrentWeatherEvent, CurrentWeatherState>
    implements CurrentWeatherBloc {}

class MockWeatherForecastBloc
    extends MockBloc<WeatherForecastEvent, WeatherForecastState>
    implements WeatherForecastBloc {}

class MockLocationService extends Mock implements LocationService {}

class MockOpenWeatherCLient extends Mock implements OpenWeatherClient {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();
  late MockLocationService mockLocationService;
  late MockOpenWeatherCLient mockOpenWeatherCLient;
  late MockCurrentWeatherBloc mockCurrentWeatherBloc;
  late MockWeatherForecastBloc mockWeatherForecastBloc;

  setUp(() async {
    await Firebase.initializeApp();

    mockLocationService = MockLocationService();
    mockOpenWeatherCLient = MockOpenWeatherCLient();
    mockCurrentWeatherBloc = MockCurrentWeatherBloc();
    mockWeatherForecastBloc = MockWeatherForecastBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<CurrentWeatherBloc>(
              create: (context) => mockCurrentWeatherBloc),
          BlocProvider<WeatherForecastBloc>(
              create: (context) => mockWeatherForecastBloc)
        ],
        child: HomePage(
          locationService: mockLocationService,
          openWeatherClient: mockOpenWeatherCLient,
        ),
      ),
    );
  }

  const chicagoLocation = GeoPoint(41, -87);

  arrangeLocationPluginReturnLocation() {
    when(() => mockLocationService.getCurrentLocation())
        .thenAnswer((_) async => chicagoLocation);
  }

  final weatherData = WeatherData(
      main: 'main',
      city: 'Puerto Escondido',
      windSpeed: 34,
      timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      temp: 86,
      humidity: 56);

  group("home page state change", () {
    testWidgets("""App title is present, 
    indicator is displayed while waiting for current weather data,
    """, (widgetTester) async {
      arrangeLocationPluginReturnLocation();
      when(() => mockCurrentWeatherBloc.state)
          .thenReturn(CurrentWeatherInitial());
      await widgetTester.pumpWidget(createWidgetUnderTest());
      expect(find.text('SKYWATCH'), findsOneWidget);
      expect(find.byType(Lottie), findsOneWidget);
    });

    testWidgets("Page Content is displayed once weather data arrived",
        (widgetTester) async {
      arrangeLocationPluginReturnLocation();
      when(() => mockCurrentWeatherBloc.state).thenReturn(
          CurrentWeatherInitial()); // stub state rather than initialState
      when(() => mockWeatherForecastBloc.state).thenReturn(
          WeatherForecastInitial()); // stub state rather than initialState

      whenListen<CurrentWeatherState>(mockCurrentWeatherBloc,
          Stream.fromIterable([CurrentWeatherLoaded(weatherData)]));
      await widgetTester.pumpWidget(createWidgetUnderTest());
      await widgetTester.pump();
      expect(find.byKey(const Key("home_page_stack")), findsOneWidget);
    });
  });
}
