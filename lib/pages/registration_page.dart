import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:auth_buttons/auth_buttons.dart'
    show AuthButtonStyle, EmailAuthButton;
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import 'package:studiconnect/controllers/authentication.dart';
import 'package:studiconnect/main.dart';
import 'package:studiconnect/models/redux/app_state.dart';
import 'package:studiconnect/services/logger_provider.dart';
import 'package:studiconnect/widgets/error_label.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _passwordRepeatController;
  late final ValueNotifier<String> _errorMessageNotifier;

  bool _isObscure = true;
  bool _isObscureRepeat = true;
  bool _emailButtonLoading = false;


  @override
  void initState() {
    log("Iniatilizing RegisterPage...");
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordRepeatController = TextEditingController();
    _errorMessageNotifier = ValueNotifier("");
  }

  @override
  void dispose() {
    log("Disposing RegisterPage...");
    _emailController.dispose();
    _passwordController.dispose();
    _passwordRepeatController.dispose();
    _errorMessageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("Building RegisterPage...");
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (BuildContext context, AppState state) {
          return PageWrapper(
            title: "Registrieren",
            type: PageType.simple,
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
                        _errorMessageNotifier.value = "Bitte füllen Sie alle Felder aus.";
                        return;
                      }

                      if (_passwordController.text != _passwordRepeatController.text) {
                        _errorMessageNotifier.value = "Die Passwörter stimmen nicht überein.";
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
                          "invalid-email": "Die E-Mail Adresse ist ungültig.",
                          "email-already-in-use": "Die E-Mail Adresse wird bereits verwendet.",
                          "weak-password": "Das Passwort ist zu schwach.",
                          "channel-error": "Ein Fehler ist aufgetreten.",
                          "too-many-requests": "Zu viele Anfragen. Bitte versuchen Sie es später erneut.",
                          "operation-not-allowed": "Die Registrierung ist nicht erlaubt.",
                          "network-request-failed": "Keine Internetverbindung.",
                        };

                        _errorMessageNotifier.value = errorMessages[e.code] ?? "${e.code}: ${e.message}";

                        setState(() {
                          _emailButtonLoading = false;
                        });
                        return;
                      } catch (e) {
                        showToast(e.toString());
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
                    text: "Konto erstellen",
                    isLoading: _emailButtonLoading,
                    style: AuthButtonStyle(
                      textStyle: TextStyle(
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          color: Theme.of(context).textTheme.labelSmall?.color),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
