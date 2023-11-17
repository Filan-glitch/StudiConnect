import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Mit deiner Anmeldung stimmst du unseren AGBs zu. In unserer Datenschutzerklärung findest du weitere Informationen zur Verarbeitung deiner Daten.',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width - 20, 40)),
                textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(color: Colors.white, fontSize: 18, fontFamily: GoogleFonts.kalam().fontFamily)),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Registrieren'),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              style: ButtonStyle(
                //Button should be 5px smaller on each side than the maximum screen size in width and it should be dynamic to all screen sizes
                minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width - 20, 40)),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(color: Colors.white, fontSize: 18, fontFamily: GoogleFonts.kalam().fontFamily)),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Anmelden'),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}