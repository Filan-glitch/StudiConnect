import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auth_buttons/auth_buttons.dart'
    show AuthButtonStyle, EmailAuthButton, GoogleAuthButton;

import '../controllers/authentication.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _emailButtonLoading = false;
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
