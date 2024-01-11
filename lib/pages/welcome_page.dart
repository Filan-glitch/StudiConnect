/// This library contains the WelcomePage widget.
///
/// {@category PAGES}
library pages.welcome_page;

import 'dart:math';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studiconnect/controllers/authentication.dart';
import 'package:studiconnect/main.dart';
import 'package:studiconnect/models/redux/app_state.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:studiconnect/constants.dart';

/// A StatefulWidget that provides the user with the option to register or log in.
///
/// The page contains buttons to register with email or Google,
/// as well as a link to the login page.
/// The user is also presented with the terms of service and privacy policy.
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

/// The state for the [WelcomePage] widget.
///
/// This class contains the logic for handling the user's interactions with the page.
class _WelcomePageState extends State<WelcomePage> {
  /// Whether the Google login button is currently loading.
  bool _googleButtonLoading = false;

  @override
  void initState() {
    super.initState();
    /// Sets the system UI overlay style to dark.
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    final double _screenHeight = MediaQuery.of(context).size.height;

    return PageWrapper(
      type: PageType.empty,
      title: 'Willkommen',
      body: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: _screenHeight * 0.05, bottom: _screenHeight * 0.05),
                    child: Image.asset(
                      'assets/icons/icon.png',
                      width: min(_screenWidth * 0.45, 300),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: _screenWidth * 0.1, vertical: _screenHeight * 0.025),
                    child: Text(
                      'Willkommen bei StudiConnect',
                      style:
                          TextStyle(fontSize: _screenHeight * 0.045, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: _screenWidth * 0.1, vertical: _screenHeight * 0.02),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: _screenHeight * 0.02),
                        children: <TextSpan>[
                          const TextSpan(
                            text: 'Mit deiner Anmeldung stimmst du unseren ',
                          ),
                          TextSpan(
                              text: 'AGBs',
                              style: const TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launchUrl(
                                    Uri.parse(
                                      termsURL,
                                    ),
                                    mode: LaunchMode.inAppWebView,
                                  );
                                }),
                          const TextSpan(
                            text: ' zu. In unserer ',
                          ),
                          TextSpan(
                              text: 'Datenschutzerklärung',
                              style: const TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launchUrl(
                                    Uri.parse(
                                      privacyURL,
                                    ),
                                    mode: LaunchMode.inAppWebView,
                                  );
                                }),
                          const TextSpan(
                            text:
                                ' findest du weitere Informationen zur Verarbeitung deiner Daten.',
                          ),
                        ],
                      ),
                    ),
                  ),
                  EmailAuthButton(
                    themeMode: Theme.of(context).brightness == Brightness.light
                        ? ThemeMode.light
                        : ThemeMode.dark,
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    text: 'Konto erstellen',
                    style: AuthButtonStyle(
                      textStyle: TextStyle(
                        fontSize: _screenHeight * 0.02,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        color: Theme.of(context).textTheme.labelSmall?.color
                      ),
                    ),
                  ),
                  GoogleAuthButton(
                    onPressed: () async {
                      setState(() {
                        _googleButtonLoading = true;
                      });

                      final bool? isNewUser = await signInWithGoogle();

                      setState(() {
                        _googleButtonLoading = false;
                      });

                      if (isNewUser == true) {
                        navigatorKey.currentState!.pushNamed('/edit-profile');
                      }
                    },
                    isLoading: _googleButtonLoading,
                    themeMode: Theme.of(context).brightness == Brightness.light
                        ? ThemeMode.light
                        : ThemeMode.dark,
                    text: 'Mit Google anmelden',
                    style: AuthButtonStyle(
                      textStyle: TextStyle(
                        fontSize: _screenHeight * 0.02,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: _screenWidth * 0.1, right: _screenWidth * 0.1, bottom: _screenHeight * 0.07),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: _screenHeight * 0.02),
                        children: <TextSpan>[
                          const TextSpan(
                            text: 'Du hast bereits ein Konto? ',
                          ),
                          TextSpan(
                              text: 'Login!',
                              style: const TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(context, '/login');
                                }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}