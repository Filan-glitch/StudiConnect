import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studiconnect/controllers/authentication.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';

import '../widgets/error_label.dart';

class PasswordChangePage extends StatelessWidget {
  PasswordChangePage({super.key});

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPasswordRepeatController = TextEditingController();
  final ValueNotifier<String> _errorMessageNotifier = ValueNotifier("");

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
        title: "Passwort ändern",
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 50.0,
              left: 30.0,
              right: 30.0,
            ),
            child: Column(
                children: [
                  TextField(
                    controller: _oldPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                      labelText: 'Altes Passwort',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                      labelText: 'Neues Passwort',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _newPasswordRepeatController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                      labelText: 'Neues Passwort wiederholen',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: ErrorLabel(
                        errorMessageNotifier: _errorMessageNotifier
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () async {
                      if(_oldPasswordController.text.isEmpty || _newPasswordController.text.isEmpty || _newPasswordRepeatController.text.isEmpty) {
                        _errorMessageNotifier.value = "Bitte fülle alle Felder aus.";
                        return;
                      }
                      if (_newPasswordController.text != _newPasswordRepeatController.text) {
                        _errorMessageNotifier.value = "Die Passwörter stimmen nicht überein.";
                        return;
                      }
                      if (_oldPasswordController.text == _newPasswordController.text) {
                        _errorMessageNotifier.value = "Das neue Passwort darf nicht mit dem alten Passwort übereinstimmen.";
                        return;
                      }

                      try {
                        await updatePassword(
                            _oldPasswordController.text,
                            _newPasswordController.text
                        );
                      } on FirebaseAuthException catch (e) {
                        final errorMessages = {
                          'user-not-found': "Das Konto existiert nicht mehr.",
                          'user-disabled': "Das Konto ist deaktiviert.",
                          'too-many-requests': "Zu viele Anfragen. Bitte versuche es später erneut.",
                          'operation-not-allowed': "Diese Anmeldung ist nicht erlaubt.",
                          'network-request-failed': "Keine Internetverbindung.",
                          'invalid-credential': "Das alte Passwort ist ungültig.",
                        };
                        _errorMessageNotifier.value = errorMessages[e.code] ?? "${e.code}: ${e.message}";
                      } catch (e) {
                        _errorMessageNotifier.value = "Ein unbekannter Fehler ist aufgetreten.";
                      }
                    },
                    child: const Text("Passwort ändern"),
                  ),
                ],
            ),
          ),
        )
    );
  }
}
