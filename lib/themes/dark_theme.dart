/// This library contains the dark theme for the application.
///
/// {@category THEMES}
library themes.dark_theme;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The dark theme for the application.
///
/// This theme uses the Material 3 design system and the Roboto font.
/// The primary color is a dark blue (#3e3699), and the secondary color is a brighter blue (#0032bb).
/// The error color is red.
/// The background color for the scaffold is a very dark purple (#0b0421).
/// The text color is white.
/// Elevated buttons have a background color matching the primary color, a text color of white, and a bold, 20-point font.
ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  fontFamily: GoogleFonts.roboto().fontFamily,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xff3e3699),
    secondary: Color(0xff0032bb),
    error: Colors.red,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xff3e3699),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 11, 4, 33),
  textTheme: GoogleFonts.robotoTextTheme()
      .apply(bodyColor: Colors.white, displayColor: Colors.white),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      alignment: Alignment.center,
      backgroundColor: MaterialStateProperty.all<Color>(
        const Color(0xff3e3699),
      ),
      foregroundColor: MaterialStateProperty.all<Color>(
        Colors.white,
      ),
      textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  ),
);