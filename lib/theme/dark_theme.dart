import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  colorScheme: const ColorScheme.dark(
    brightness: Brightness.dark,
    surface: Color(0xff2a2e4b),
    primary: Color(0xff311B92),
    secondary: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff2a2e4b),
      foregroundColor: Color(0xff311B92),
      titleTextStyle: TextStyle(
        fontSize: 14,
      )),
  textTheme: const TextTheme(
    labelSmall: TextStyle(
      color: Colors.white,
      fontSize: 14,
    ),
  ),
);
