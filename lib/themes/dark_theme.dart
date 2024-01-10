import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  fontFamily: GoogleFonts.roboto().fontFamily,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xff3e3699),

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
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    refreshBackgroundColor: Color(0x492787), // Should be little bit darker than primary color
    color: Color(0xff3e3699),
  ),
);
