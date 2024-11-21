import 'package:flutter/material.dart';
import 'package:starman/theme/color_const.dart';

final lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    brightness: Brightness.light,
    surface: ColorConst.lightSurface,
    primary: ColorConst.lightPrimary,
    secondary: Colors.white,
  ),
  expansionTileTheme: const ExpansionTileThemeData(
    collapsedTextColor: Colors.white,
    collapsedIconColor: Colors.white,
  ),
  listTileTheme: const ListTileThemeData(
    textColor: Colors.white,
  ),
  appBarTheme: AppBarTheme(
      backgroundColor: ColorConst.lightPrimary,
      foregroundColor: Colors.white,
      titleTextStyle: const TextStyle(
        fontSize: 14,
      )),
  textTheme: const TextTheme(
    labelLarge: TextStyle(
      color: Colors.green,
      fontSize: 13,
    ),
    labelSmall: TextStyle(
      color: Colors.black,
      fontSize: 11,
    ),
    bodyMedium: TextStyle(
      color: Colors.white,
      fontSize: 13,
    ),
  ),
);
