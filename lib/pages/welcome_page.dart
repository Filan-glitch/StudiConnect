import 'package:auth_buttons/auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studiconnect/services/firebase/authentication.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _googleButtonLoading = false;

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
                        recognizer: TapGestureRecognizer()..onTap = () {}),
                    const TextSpan(
                      text: ' zu. In unserer ',
                    ),
                    TextSpan(
                        text: 'Datenschutzerklärung',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()..onTap = () {}),
                    const TextSpan(
                      text:
                          ' findest du weitere Informationen zur Verarbeitung deiner Daten.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            EmailAuthButton(
              onPressed: () {
                Navigator.pushNamed(context, "/register");
              },
              text: "Konto erstellen",
              style: AuthButtonStyle(
                textStyle: TextStyle(
                  fontFamily: GoogleFonts.roboto().fontFamily,
                ),
              ),
            ),
            const SizedBox(height: 5),
            GoogleAuthButton(
              onPressed: () {
                setState(() {
                  _googleButtonLoading = true;
                });
                // TODO: call controller
                signInWithGoogle().then((String? userCredential) {
                  if (userCredential != null) {
                    //TODO: API call to obtain user data

                    Navigator.pushNamedAndRemoveUntil(
                        context, "/groups", (route) => false);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Es ist ein Fehler aufgetreten."),
                      ),
                    );
                  }
                });
                setState(() {
                  _googleButtonLoading = false;
                });
              },
              isLoading: _googleButtonLoading,
              text: "Mit Google anmelden",
              style: AuthButtonStyle(
                textStyle: TextStyle(
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Du hast bereits ein Konto? ',
                    ),
                    TextSpan(
                        text: 'Login!',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, "/login");
                          }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
