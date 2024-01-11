/// This library contains the DeleteAccountPage widget.
///
/// {@category PAGES}
library pages.delete_account_page;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:studiconnect/controllers/user.dart';
import 'package:studiconnect/models/redux/app_state.dart';
import 'package:studiconnect/widgets/error_label.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';

/// A StatelessWidget that provides the user with the option to delete their account.
///
/// The page contains a text field for the user to enter their password (if necessary),
/// and a button to confirm the deletion of the account.
class DeleteAccountPage extends StatelessWidget {
  DeleteAccountPage({super.key});

  /// The controller for the password text field.
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<String> _errorMessageNotifier = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      title: 'Konto löschen',
      body: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (context, state) {
            /// Determines whether the user needs to enter their password to delete their account.
            final bool passwordNeeded = state.authProviderType == 'email';
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete_forever,
                      size: 100, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 20),
                  const Text('Konto löschen', style: TextStyle(fontSize: 30)),
                  const SizedBox(height: 20),
                  const Text(
                    'Sind Sie sicher, dass Sie Ihr Konto löschen möchten?',
                  ),
                  const SizedBox(height: 20),
                  if (passwordNeeded) ...[
                    const Text(
                      'Bitte geben Sie Ihr Passwort ein, um fortzufahren:',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: SizedBox(
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Passwort',
                          ),
                        ),
                      ),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ErrorLabel(
                      errorMessageNotifier: _errorMessageNotifier,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.background,
                      side: const BorderSide(
                        color: Colors.red,
                        width: 2.0,
                      ),
                    ),
                    onPressed: () async {
                      try {
                        await deleteAccount(_passwordController.text);
                      } on FirebaseAuthException catch (e) {
                        final errorMessages = {
                          'wrong-password': 'Das Passwort ist falsch.',
                          'user-disabled': 'Dieser Nutzer wurde deaktiviert.',
                          'too-many-requests': 'Zu viele Anfragen. Bitte versuche es später erneut.',
                          'operation-not-allowed': 'Diese Anmeldung ist nicht erlaubt.',
                          'network-request-failed': 'Keine Internetverbindung.',
                          'invalid-credential': 'Die Anmeldeinformationen sind ungültig.',
                        };

                        _errorMessageNotifier.value = errorMessages[e.code] ?? '${e.code}: ${e.message}';
                        return;
                      } catch (e) {
                        _errorMessageNotifier.value = 'Ein unbekannter Fehler ist aufgetreten.';
                        return;
                      }
                    },
                    child: const Text(
                      'Konto löschen',
                      style: TextStyle(
                        color: Colors.red,
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