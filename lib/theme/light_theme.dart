import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    brightness: Brightness.light,
    surface: Colors.grey.shade100,
    primary: Colors.green,
    secondary: Colors.white,
  ),
  textTheme: const TextTheme(
    labelLarge: TextStyle(
      color: Colors.green,
      fontSize: 13,
    ),
    labelSmall: TextStyle(
      color: Colors.black,
      fontSize: 11,
    ),
  ),
);
