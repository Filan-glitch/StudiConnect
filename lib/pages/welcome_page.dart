/// This library contains the WelcomePage widget.
///
/// {@category PAGES}
library pages.welcome_page;

import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studiconnect/controllers/authentication.dart';
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
    return PageWrapper(
      type: PageType.empty,
      title: "Willkommen",
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            /// The application's logo.
            Image.asset(
              "assets/icons/icon.png",
              width: 200,
            ),
            const SizedBox(height: 50),
            /// The welcome message.
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Willkommen bei StudiConnect',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 100),
            /// The terms of service and privacy policy.
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
            const SizedBox(height: 5),
            /// The button to register with email.
            EmailAuthButton(
              themeMode: Theme.of(context).brightness == Brightness.light
                  ? ThemeMode.light
                  : ThemeMode.dark,
              onPressed: () {
                Navigator.pushNamed(context, "/register");
              },
              text: "Konto erstellen",
              style: AuthButtonStyle(
                textStyle: TextStyle(
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    color: Theme.of(context).textTheme.labelSmall?.color),
              ),
            ),
            const SizedBox(height: 5),
            /// The button to register with Google.
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
              isLoading: _googleButtonLoading,
              themeMode: Theme.of(context).brightness == Brightness.light
                  ? ThemeMode.light
                  : ThemeMode.dark,
              text: "Mit Google anmelden",
              style: AuthButtonStyle(
                textStyle: TextStyle(
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 5),
            /// The link to the login page.
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
                          }),
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