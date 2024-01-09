import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
