import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  fontFamily: GoogleFonts.roboto().fontFamily,
  colorScheme: const ColorScheme.dark(
    primary: Color.fromARGB(255, 114, 243, 33),
    secondary: Color.fromARGB(255, 255, 205, 68),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 114, 243, 33),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
  textTheme: GoogleFonts.robotoTextTheme().apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      alignment: Alignment.center,
      backgroundColor: MaterialStateProperty.all<Color>(
        const Color.fromARGB(255, 114, 243, 33),
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
