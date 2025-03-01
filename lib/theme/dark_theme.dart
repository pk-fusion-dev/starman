import 'package:flutter/material.dart';
import 'package:starman/theme/color_const.dart';

final darkTheme = ThemeData(
  fontFamily: "pyidaungsu_1.8.3_Regular",
  colorScheme: ColorScheme.light(
    brightness: Brightness.light,
    surface: ColorConst.lightSurface,
    primary: ColorConst.lightPrimary,
    secondary: Colors.white,
  ),
  expansionTileTheme: ExpansionTileThemeData(
    collapsedTextColor: Colors.white,
    collapsedIconColor: Colors.white,
    textColor: ColorConst.lightPrimary,
  ),
  listTileTheme: const ListTileThemeData(
    textColor: Colors.white,
  ),
  appBarTheme: AppBarTheme(
      backgroundColor: ColorConst.lightPrimary,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: ColorConst.lightSurface,
        fontSize: 14,
        // fontWeight: FontWeight.bold,
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
