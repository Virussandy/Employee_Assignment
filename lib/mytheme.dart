import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData customTheme = ThemeData(
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color.fromRGBO(29, 161, 242, 1),
    foregroundColor: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    color: Color.fromRGBO(29, 161, 242, 1),
    titleTextStyle: TextStyle(
      fontSize: ScreenUtil().setSp(16),
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
    iconTheme: IconThemeData(color: Colors.black), // Dark icon colors
  ),
  primaryColor: const Color.fromRGBO(29, 161, 242, 1),
  primaryIconTheme: const IconThemeData(color: Color.fromRGBO(29, 161, 242, 1)), // Dark icon colors
  buttonTheme: const ButtonThemeData(
    buttonColor: Color.fromRGBO(29, 161, 242, 1), // Light button background color
    textTheme: ButtonTextTheme.primary,
  ),
  hintColor: const Color.fromRGBO(148, 156, 158, 1), // TextHint color
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color.fromRGBO(50, 50, 56, 1)), // Text color
    titleMedium: TextStyle(color: Color.fromRGBO(50, 50, 56, 1)), // Title text color
    titleSmall: TextStyle(color: Color.fromRGBO(148, 156, 158, 1)), // Subtitle text color
    labelLarge: TextStyle(color: Colors.white), // Light button text color
  ),
  colorScheme: const ColorScheme.light(background: Colors.white),
  cardColor: const Color.fromRGBO(237, 248, 255, 1),
  dividerColor: Color.fromRGBO(242, 242, 242, 1),// Light button background color
  scaffoldBackgroundColor: Colors.white, // Screen background color
  iconTheme: const IconThemeData(color: Colors.white), // Light icon color
  canvasColor: Colors.white, // Background of static text
  inputDecorationTheme: InputDecorationTheme(
    contentPadding:EdgeInsets.zero,
    border: OutlineInputBorder(
      gapPadding: ScreenUtil().setWidth(12),
        borderRadius:
        BorderRadius.circular(ScreenUtil().radius(4))),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: const Color.fromRGBO(229, 229, 229, 1),
            width: ScreenUtil().setWidth(1.0))),
  ),
);
