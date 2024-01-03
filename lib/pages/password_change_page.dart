/// This library contains the PasswordChangePage widget.
///
/// {@category PAGES}
library pages.password_change_page;

import 'package:flutter/material.dart';
import 'package:studiconnect/controllers/authentication.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';

/// A StatefulWidget that allows the user to change their password.
///
/// The page contains text fields for the user to enter their old password and their new password twice,
/// as well as a button to confirm the password change.
class PasswordChangePage extends StatefulWidget {
  const PasswordChangePage({super.key});

  @override
  State<PasswordChangePage> createState() => _PasswordChangePageState();
}

/// The state for the [PasswordChangePage] widget.
///
/// This class contains the logic for handling the user's input and changing the password.
class _PasswordChangePageState extends State<PasswordChangePage> {
  /// The controller for the old password text field.
  final TextEditingController _oldPasswordController = TextEditingController();

  /// The controller for the new password text field.
  final TextEditingController _newPasswordController = TextEditingController();

  /// The controller for the new password repeat text field.
  final TextEditingController _newPasswordRepeatController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    /// Whether the new password and its repetition are valid.
    bool passwordValid =
        _newPasswordController.text == _newPasswordRepeatController.text &&
            _newPasswordController.text.isNotEmpty &&
            _newPasswordRepeatController.text.isNotEmpty &&
            _oldPasswordController.text.isNotEmpty;

    return PageWrapper(
        title: "Passwort ändern",
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 50.0,
              left: 30.0,
              right: 30.0,
            ),
            child: Column(children: [
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
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: passwordValid
                    ? () {
                        updatePassword(_oldPasswordController.text,
                            _newPasswordController.text);
                      }
                    : null,
                child: const Text("Passwort ändern"),
              ),
            ]),
          ),
        ));
  }
}