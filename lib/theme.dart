import 'package:flutter/material.dart';

const KbackgroundColor = Color(0XFF0091ad);

ThemeData theme(BuildContext context) {
  return ThemeData(
      // primaryColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
      useMaterial3: true,
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: Colors.white),
      scaffoldBackgroundColor: KbackgroundColor,
      iconTheme: const IconThemeData(color: Colors.white),
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 18,
          )));
}
