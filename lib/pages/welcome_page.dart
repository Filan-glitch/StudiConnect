import 'package:auth_buttons/auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}


class _WelcomePageState extends State<WelcomePage> {
  bool _googleButtonLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // send id token to backend
    //     http.post(Uri.parse("http://10.0.2.2:8080/api/login"),
    //         body: """mutation login {
    //     login(token: "${googleAuth?.idToken}") {
    //         sessionID
    //     }
    // }""");

    // Once signed in, return the UserCredential
    return await _auth.signInWithCredential(credential);
  }

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
            EmailAuthButton(
              onPressed: () {
                Navigator.pushNamed(context, "/register");
              },
              text: "Konto erstellen",
              style: AuthButtonStyle(
                textStyle: TextStyle(
                  fontFamily: GoogleFonts.kalam().fontFamily,
                ),
              ),
            ),
            const SizedBox(height: 5),
            GoogleAuthButton(
              onPressed: () {
                setState(() {
                  _googleButtonLoading = true;
                });
                signInWithGoogle();
                setState(() {
                  _googleButtonLoading = false;
                });
              },
              isLoading: _googleButtonLoading,
              text: "Mit Google anmelden",
              style: AuthButtonStyle(
                textStyle: TextStyle(
                  fontFamily: GoogleFonts.kalam().fontFamily,
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
                          }
                    ),
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