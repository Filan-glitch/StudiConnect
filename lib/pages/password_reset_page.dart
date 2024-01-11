/// This library contains the PasswordResetPage widget.
///
/// {@category PAGES}
library pages.password_reset_page;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studiconnect/controllers/authentication.dart';
import 'package:studiconnect/main.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';
import 'package:studiconnect/widgets/error_label.dart';

/// A StatelessWidget that provides the user with the option to reset their password.
///
/// The page contains a text field for the user to enter their email,
/// as well as a button to trigger the password reset.
class PasswordResetPage extends StatelessWidget {
  PasswordResetPage({super.key});

  /// The controller for the email text field.
  final TextEditingController _emailController = TextEditingController();
  final ValueNotifier<String> _errorMessageNotifier = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      title: 'Passwort zurücksetzen',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// The title of the page is "Passwort zurücksetzen".
            const Text(
              'Passwort zurücksetzen',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            /// The text instructs the user to enter their email to reset their password.
            const Text(
              'Gib deine E-Mail-Adresse ein, um dein Passwort zurückzusetzen.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-Mail-Adresse',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 5.0),
              child: ErrorLabel(
                  errorMessageNotifier: _errorMessageNotifier
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: 300.0,
              child: ElevatedButton(
                /// When the button is pressed, the password reset is triggered for the entered email,
                /// and the user is navigated back to the previous page.
                onPressed: () {
                  triggerPasswordReset(_emailController.text);
                  Navigator.pop(context);
                },
                child: const Text("Passwort zurücksetzen"),
              ),
            ElevatedButton(
              onPressed: () async {
                if(_emailController.text.isEmpty) {
                  _errorMessageNotifier.value = 'Bitte gib deine E-Mail-Adresse ein.';
                  return;
                }
                try {
                  await triggerPasswordReset(_emailController.text);
                } on FirebaseAuthException catch (e) {
                  final errorMessages = {
                    'invalid-email': 'Die E-Mail Adresse ist ungültig.',
                    'too-many-requests': 'Zu viele Anfragen. Bitte versuchen Sie es später erneut.',
                    'operation-not-allowed': 'Die Registrierung ist nicht erlaubt.',
                    'network-request-failed': 'Keine Internetverbindung.',
                    'user-not-found': 'Es wurde kein Benutzer mit dieser E-Mail-Adresse gefunden.',
                  };

                  _errorMessageNotifier.value = errorMessages[e.code] ?? '${e.code}: ${e.message}';
                  return;
                } catch (e) {
                  _errorMessageNotifier.value = e.toString();
                  return;
                }

                navigatorKey.currentState!.pop();
              },
              child: const Text('Passwort zurücksetzen'),
            ),
          ],
        ),
      ),
    );
  }
}