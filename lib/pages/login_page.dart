/// This library contains the LoginPage widget.
///
/// {@category PAGES}
library pages.login_page;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auth_buttons/auth_buttons.dart'
    show AuthButtonStyle, EmailAuthButton, GoogleAuthButton;
import 'package:studiconnect/controllers/authentication.dart';

/// A StatefulWidget that provides the user with the option to log in.
///
/// The page contains text fields for the user to enter their email and password,
/// as well as buttons to log in with email or Google.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

/// The state for the [LoginPage] widget.
///
/// This class contains the logic for handling the user's input and logging in.
class _LoginPageState extends State<LoginPage> {
  /// The controller for the email text field.
  final TextEditingController _emailController = TextEditingController();

  /// The controller for the password text field.
  final TextEditingController _passwordController = TextEditingController();

  /// Whether the email login button is currently loading.
  bool _emailButtonLoading = false;

  /// Whether the Google login button is currently loading.
  bool _googleButtonLoading = false;

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
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
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
              const SizedBox(height: 30),
              EmailAuthButton(
                onPressed: () async {
                  setState(() {
                    _emailButtonLoading = true;
                  });

                  await signInWithEmailAndPassword(
                    _emailController.text,
                    _passwordController.text,
                  );

                  setState(() {
                    _emailButtonLoading = false;
                  });
                },
                isLoading: _emailButtonLoading,
                text: "Mit E-Mail anmelden",
                themeMode: Theme.of(context).brightness == Brightness.light
                    ? ThemeMode.light
                    : ThemeMode.dark,
                style: AuthButtonStyle(
                  textStyle: TextStyle(
                    fontFamily: GoogleFonts.roboto().fontFamily,
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
                          Navigator.pushNamed(context, '/login-help');
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              GoogleAuthButton(
                onPressed: () async {
                  setState(() {
                    _googleButtonLoading = true;
                  });

                  await signInWithGoogle();

                  setState(() {
                    _googleButtonLoading = false;
                  });
                },
                themeMode: Theme.of(context).brightness == Brightness.light
                    ? ThemeMode.light
                    : ThemeMode.dark,
                isLoading: _googleButtonLoading,
                text: "Mit Google anmelden",
                style: AuthButtonStyle(
                  textStyle: TextStyle(
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}