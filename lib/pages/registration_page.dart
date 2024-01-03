/// This library contains the RegisterPage widget.
///
/// {@category PAGES}
library pages.register_page;

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:auth_buttons/auth_buttons.dart'
    show AuthButtonStyle, EmailAuthButton;
import 'package:google_fonts/google_fonts.dart';
import 'package:studiconnect/controllers/authentication.dart';
import 'package:studiconnect/models/redux/app_state.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';

/// A StatefulWidget that provides the user with the option to register.
///
/// The page contains text fields for the user to enter their email and password,
/// as well as a button to confirm the registration.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

/// The state for the [RegisterPage] widget.
///
/// This class contains the logic for handling the user's input and registering.
class _RegisterPageState extends State<RegisterPage> {
  /// The controller for the email text field.
  final TextEditingController _emailController = TextEditingController();

  /// The controller for the password text field.
  final TextEditingController _passwordController = TextEditingController();

  /// The controller for the password repeat text field.
  final TextEditingController _passwordRepeatController =
      TextEditingController();

  /// Whether the password field is currently obscured.
  bool _isObscure = true;

  /// Whether the password repeat field is currently obscured.
  bool _isObscureRepeat = true;

  /// Whether the email registration button is currently loading.
  bool _emailButtonLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordRepeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (BuildContext context, AppState state) {
          return PageWrapper(
            title: "Registrieren",
            type: PageType.empty,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
                  const SizedBox(height: 30),
                  EmailAuthButton(
                    themeMode: Theme.of(context).brightness == Brightness.light
                        ? ThemeMode.light
                        : ThemeMode.dark,
                    // TODO: set null if not valid
                    onPressed: () {
                      setState(() {
                        _emailButtonLoading = true;
                      });

                      signUpWithEmailAndPassword(
                        _emailController.text,
                        _passwordController.text,
                      );

                      setState(() {
                        _emailButtonLoading = false;
                      });
                      Navigator.pushNamed(context, "/further-registration");
                    },
                    text: "Konto erstellen",
                    isLoading: _emailButtonLoading,
                    style: AuthButtonStyle(
                      textStyle: TextStyle(
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          color: Theme.of(context).textTheme.labelSmall?.color),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        });
  }
}