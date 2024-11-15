import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    brightness: Brightness.dark,
    surface : Colors.grey.shade800,
    primary: Colors.green.shade800,
    secondary: Colors.white,
  ),
  textTheme: const TextTheme(
    labelSmall: TextStyle(
      color: Colors.white,
      fontSize: 14,
    ),
  ),
);