/// This library contains the LoginPage widget.
///
/// {@category PAGES}
library pages.login_page;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auth_buttons/auth_buttons.dart'
    show AuthButtonStyle, EmailAuthButton;
import 'package:studiconnect/controllers/authentication.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';
import 'package:studiconnect/widgets/error_label.dart';

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
  late final TextEditingController _emailController;

  /// The controller for the password text field.
  late final TextEditingController _passwordController;

  late final ValueNotifier<String> _errorMessageNotifier;

  /// Whether the email login button is currently loading.
  bool _emailButtonLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _errorMessageNotifier = ValueNotifier('');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _errorMessageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
        title: 'Anmelden',
        type: PageType.simple,
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
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
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
              // Error Label, invisible if no error
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: ErrorLabel(
                  errorMessageNotifier: _errorMessageNotifier,
                ),
              ),
              const SizedBox(height: 30),
              EmailAuthButton(
                onPressed: () async {
                  if(_emailButtonLoading) return;

                  if(_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                    setState(() {
                      _errorMessageNotifier.value = 'Bitte fülle alle Felder aus.';
                    });
                    return;
                  }

                  setState(() {
                    _emailButtonLoading = true;
                  });

                  try {
                    await signInWithEmailAndPassword(
                      _emailController.text,
                      _passwordController.text,
                    );
                  } on FirebaseAuthException catch (e) {
                    final errorMessages = {
                      'user-not-found': 'Es existiert kein Nutzer mit dieser E-Mail.',
                      'wrong-password': 'Das Passwort ist falsch.',
                      'invalid-email': 'Die E-Mail ist ungültig.',
                      'user-disabled': 'Dieser Nutzer wurde deaktiviert.',
                      'too-many-requests': 'Zu viele Anfragen. Bitte versuche es später erneut.',
                      'operation-not-allowed': 'Diese Anmeldung ist nicht erlaubt.',
                      'network-request-failed': 'Keine Internetverbindung.',
                      'invalid-credential': 'Die Anmeldeinformationen sind ungültig.',
                      'account-exists-with-different-credential': 'Es existiert bereits ein Nutzer mit dieser E-Mail und einer anderen Anmeldemethode.',
                      'invalid-verification-code': 'Der Verifizierungscode ist ungültig.',
                      'invalid-verification-id': 'Die Verifizierungs-ID ist ungültig.',
                      'invalid-action-code': 'Der Aktionscode ist ungültig.',
                    };

                    setState(() {
                      _errorMessageNotifier.value = errorMessages[e.code] ?? '${e.code}: ${e.message}';
                      _emailButtonLoading = false;
                    });
                    return;
                  } catch (e) {
                    setState(() {
                      _errorMessageNotifier.value = 'Ein unbekannter Fehler ist aufgetreten.';
                      _emailButtonLoading = false;
                    });
                    return;
                  }

                  setState(() {
                    _emailButtonLoading = false;
                  });
                },
                isLoading: _emailButtonLoading,
                text: 'Mit E-Mail anmelden',
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
            ],
          ),
        )
    );
  }
}