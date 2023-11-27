import 'package:flutter/gestures.dart';
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
            //TODO: Add logo
            const SizedBox(height: 50),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Willkommen bei StudiConnect',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Mit deiner Anmeldung stimmst du unseren ',
                    ),
                    TextSpan(
                      text: 'AGBs',
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {

                        }
                    ),
                    const TextSpan(
                      text: ' zu. In unserer ',
                    ),
                    TextSpan(
                      text: 'Datenschutzerklärung',
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {

                        }
                    ),
                    const TextSpan(
                      text: ' findest du weitere Informationen zur Verarbeitung deiner Daten.',
                    ),
                  ],
                ),
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
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}