import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:auth_buttons/auth_buttons.dart'
    show AuthButtonStyle, EmailAuthButton;
import 'package:google_fonts/google_fonts.dart';
import '/controllers/authentication.dart';

import '/models/redux/app_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordRepeatController =
      TextEditingController();

  bool _isObscure = true;
  bool _isObscureRepeat = true;
  bool _emailButtonLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordRepeatController.dispose();
    super.dispose();
  }

  /*Valid Password: Minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character
  bool _validatePassword() {
    return _passwordController.text != _passwordRepeatController.text &&
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
            .hasMatch(_passwordController.text);
  }*/

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (BuildContext context, AppState state) {
          return Scaffold(
            appBar: AppBar(),
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
                        color: Theme.of(context).textTheme.labelSmall?.color
                      ),
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
