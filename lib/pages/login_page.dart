import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:auth_buttons/auth_buttons.dart' show AuthButtonStyle, EmailAuthButton, GoogleAuthButton;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _googleButtonLoading = false;
  bool _emailButtonLoading = false;

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

  Future<UserCredential> signInWithEmail() async {
    return await _auth.signInAnonymously();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Willkommen zurück!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'E-Mail',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Passwort',
                ),
              ),
            ),
            const SizedBox(height: 5),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Passwort vergessen?',
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                    ..onTap = () {
                        Navigator.pushNamed(
                          context,
                          '/login-help');
                    },
                  ),
                ],
              )
            ),
            const SizedBox(height: 30),
            EmailAuthButton(
              onPressed: () {
                setState(() {
                  _emailButtonLoading = true;
                });
                signInWithEmail();
                setState(() {
                  _emailButtonLoading = false;
                });
              },
              isLoading: _emailButtonLoading,
              text: "Mit E-Mail anmelden",
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
          ],
        ),
      )
    );
  }
}
