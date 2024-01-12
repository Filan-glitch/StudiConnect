/// This library contains the RegisterPage widget.
///
/// {@category PAGES}
library pages.register_page;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:auth_buttons/auth_buttons.dart'
    show AuthButtonStyle, EmailAuthButton;
import 'package:google_fonts/google_fonts.dart';
import 'package:studiconnect/controllers/authentication.dart';
import 'package:studiconnect/main.dart';
import 'package:studiconnect/models/redux/app_state.dart';
import 'package:studiconnect/widgets/error_label.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';

/// A StatefulWidget that provides the user with the option to register.
///
/// The page contains text fields for the user to enter their email and password,
/// as well as a button to confirm the registration.
class RegisterPage extends StatefulWidget {

  /// Creates a [RegisterPage] widget.
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

/// The state for the [RegisterPage] widget.
///
/// This class contains the logic for handling the user's input and registering.
class _RegisterPageState extends State<RegisterPage> {
  /// The controller for the email text field.
  late final TextEditingController _emailController;

  /// The controller for the password text field.
  late final TextEditingController _passwordController;

  /// The controller for the password repeat text field.
  late final TextEditingController _passwordRepeatController;

  late final ValueNotifier<String> _errorMessageNotifier;

  /// Whether the password field is currently obscured.
  bool _isObscure = true;

  /// Whether the password repeat field is currently obscured.
  bool _isObscureRepeat = true;

  /// Whether the email registration button is currently loading.
  bool _emailButtonLoading = false;

  /// Whether the guest registration button is currently loading.
  bool _guestButtonLoading = false;

  /// Whether the guest registration button is currently visible.
  bool _guestButtonVisible = true;


  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordRepeatController = TextEditingController();
    _errorMessageNotifier = ValueNotifier('');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordRepeatController.dispose();
    _errorMessageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Hide guest login button, when keyboard is visible
    final keyboardVisibility = MediaQuery.of(context).viewInsets.bottom;
    if(keyboardVisibility > 0) {
      setState(() {
        _guestButtonVisible = false;
      });
    } else {
      setState(() {
        _guestButtonVisible = true;
      });
    }

    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (BuildContext context, AppState state) {
          return PageWrapper(
            title: 'Registrieren',
            type: PageType.simple,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Werde Mitglied!',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
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
                              labelText: 'Email',
                              constraints: BoxConstraints(
                                maxHeight: 50,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Passwort',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              ),
                              constraints: const BoxConstraints(
                                maxHeight: 50,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: TextField(
                            controller: _passwordRepeatController,
                            obscureText: _isObscureRepeat,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Passwort wiederholen',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscureRepeat
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscureRepeat = !_isObscureRepeat;
                                  });
                                },
                              ),
                              constraints: const BoxConstraints(
                                maxHeight: 50,
                              ),
                            ),
                          ),
                        ),
                        // Error Label, invisible if no error
                        ErrorLabel(
                            errorMessageNotifier: _errorMessageNotifier
                        ),
                        const SizedBox(height: 30),
                        EmailAuthButton(
                          themeMode: Theme.of(context).brightness == Brightness.light
                              ? ThemeMode.light
                              : ThemeMode.dark,
                          onPressed: () async {
                            if(_emailButtonLoading) return;

                            if(_emailController.text.isEmpty || _passwordController.text.isEmpty || _passwordRepeatController.text.isEmpty) {
                              _errorMessageNotifier.value = 'Bitte füllen Sie alle Felder aus.';
                              return;
                            }

                            if (_passwordController.text != _passwordRepeatController.text) {
                              _errorMessageNotifier.value = 'Die Passwörter stimmen nicht überein.';
                              return;
                            }


                            setState(() {
                              _emailButtonLoading = true;
                            });

                            try {
                              await signUpWithEmailAndPassword(
                                _emailController.text,
                                _passwordController.text,
                              );
                            } on FirebaseAuthException catch (e) {
                              final errorMessages = {
                                'invalid-email': 'Die E-Mail Adresse ist ungültig.',
                                'email-already-in-use': 'Die E-Mail Adresse wird bereits verwendet.',
                                'weak-password': 'Das Passwort ist zu schwach.',
                                'channel-error': 'Ein Fehler ist aufgetreten.',
                                'too-many-requests': 'Zu viele Anfragen. Bitte versuchen Sie es später erneut.',
                                'operation-not-allowed': 'Die Registrierung ist nicht erlaubt.',
                                'network-request-failed': 'Keine Internetverbindung.',
                              };

                              _errorMessageNotifier.value = errorMessages[e.code] ?? '${e.code}: ${e.message}';

                              setState(() {
                                _emailButtonLoading = false;
                              });
                              return;
                            } catch (e) {
                              _errorMessageNotifier.value = 'Ein unbekannter Fehler ist aufgetreten.';
                              setState(() {
                                _emailButtonLoading = false;
                              });
                              return;
                            }

                            setState(() {
                              _emailButtonLoading = false;
                            });

                            navigatorKey.currentState!.pushNamed('/edit-profile');
                          },
                          text: 'Konto erstellen',
                          isLoading: _emailButtonLoading,
                          style: AuthButtonStyle(
                            textStyle: TextStyle(
                                fontFamily: GoogleFonts.roboto().fontFamily,
                                color: Theme.of(context).textTheme.labelSmall?.color
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _guestButtonVisible,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Divider(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: EmailAuthButton(
                            key: const ValueKey('GuestButton'),
                            onPressed: () async {
                              if(_guestButtonLoading) return;

                              setState(() {
                                _guestButtonLoading = true;
                              });

                              await signInAsGuest();

                              setState(() {
                                _guestButtonLoading = false;
                              });
                            },
                            isLoading: _guestButtonLoading,
                            text: 'Als Gast anmelden',
                            themeMode: Theme.of(context).brightness == Brightness.light
                                ? ThemeMode.light
                                : ThemeMode.dark,
                            style: AuthButtonStyle(
                              textStyle: TextStyle(
                                  fontFamily: GoogleFonts.roboto().fontFamily,
                                  color: Theme.of(context).textTheme.labelSmall?.color
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}