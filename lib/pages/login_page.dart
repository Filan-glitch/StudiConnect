import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('StudiConnect'),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.80,
              child: const Text(
                  textAlign: TextAlign.center,
                  'Mit deiner Anmeldung stimmst du unseren AGBs zu. In unserer Datenschutzerklärung findest du weitere Informationen zur Verarbeitung deiner Daten.'),
            ),
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/mail-login');
                },
                label: const Text('Mit E-Mail anmelden'),
                icon: const Icon(Icons.login)),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/google-login');
              },
              label: const Text('Mit Google anmelden'),
              icon: SvgPicture.asset('assets/icons/google_logo.svg',
                  semanticsLabel: 'Google Logo'),
            ),
            RichText(
              text: TextSpan(
                text: 'Probleme bei der Anmeldung?',
                style: DefaultTextStyle.of(context).style,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushNamed(context, '/login-help');
                  },
              ),
            )
          ]),
    ));
  }
}
