/// This library contains the light theme for the application.
///
/// {@category THEMES}
library themes.light_theme;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The light theme for the application.
///
/// This theme uses the Material 3 design system and the Roboto font.
/// The primary color is a deep blue (#584cd7), and the secondary color is a bright yellow (#ffcd44).
/// The error color is red.
/// The background color for the scaffold is white.
/// The text color is black.
/// Elevated buttons have a background color matching the primary color, a text color of white, and a bold, 20-point font.
ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: GoogleFonts.roboto().fontFamily,
  colorScheme: const ColorScheme.light(
    primary: Color(0xff584cd7),
    error: Colors.red,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xff584cd7),
  ),
  textTheme: GoogleFonts.robotoTextTheme().apply(
    bodyColor: Colors.black,
    displayColor: Colors.black,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      alignment: Alignment.center,
      backgroundColor: MaterialStateProperty.all<Color>(
        const Color(0xff584cd7),
      ),
      foregroundColor: MaterialStateProperty.all<Color>(
        const Color.fromARGB(255, 255, 255, 255),
      ),
      textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
);