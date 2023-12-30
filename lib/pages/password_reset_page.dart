/// This library contains the PasswordResetPage widget.
///
/// {@category PAGES}
library pages.password_reset_page;

import 'package:flutter/material.dart';
import 'package:studiconnect/controllers/authentication.dart';

/// A StatelessWidget that provides the user with the option to reset their password.
///
/// The page contains a text field for the user to enter their email,
/// as well as a button to trigger the password reset.
class PasswordResetPage extends StatelessWidget {
  PasswordResetPage({super.key});

  /// The controller for the email text field.
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /// The title of the AppBar is "Passwort zurücksetzen".
        title: const Text("Passwort zurücksetzen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// The title of the page is "Passwort zurücksetzen".
            const Text(
              "Passwort zurücksetzen",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            /// The text instructs the user to enter their email to reset their password.
            const Text(
              "Gib deine E-Mail-Adresse ein, um dein Passwort zurückzusetzen.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: 300.0,
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                decoration: const InputDecoration(
                  labelText: "E-Mail-Adresse",
                ),
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
            ),
          ],
        ),
      ),
    );
  }
}