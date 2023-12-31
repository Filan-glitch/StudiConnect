import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studiconnect/controllers/authentication.dart';
import 'package:studiconnect/main.dart';
import 'package:studiconnect/models/redux/app_state.dart';
import 'package:studiconnect/services/logger_provider.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:studiconnect/constants.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _googleButtonLoading = false;

  @override
  void initState() {
    log("Iniatilizing WelcomePage...");
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }

  @override
  void dispose() {
    log("Disposing WelcomePage...");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("Building WelcomePage...");
    return PageWrapper(
      type: PageType.empty,
      title: "Willkommen",
      body: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    "assets/icons/icon.png",
                    width: 200,
                  ),
                  const SizedBox(height: 50),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Willkommen bei StudiConnect',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 100),
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
                  GoogleAuthButton(
                    onPressed: () async {
                      setState(() {
                        _googleButtonLoading = true;
                      });

                      bool? isNewUser = await signInWithGoogle();

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
            );
          }),
    );
  }
}
