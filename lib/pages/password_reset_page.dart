import 'package:flutter/material.dart';
import 'package:studiconnect/controllers/authentication.dart';

class PasswordResetPage extends StatelessWidget {
  PasswordResetPage({super.key});

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Passwort zurücksetzen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Passwort zurücksetzen",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
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
