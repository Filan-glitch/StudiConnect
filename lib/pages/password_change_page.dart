import 'package:flutter/material.dart';
import 'package:studiconnect/controllers/authentication.dart';
import 'package:studiconnect/services/logger_provider.dart';
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
    log("Building PasswordChangePage...");
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
                    padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 5.0),
                    child: ErrorLabel(
                        errorMessageNotifier: _errorMessageNotifier
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      if(_oldPasswordController.text.isEmpty || _newPasswordController.text.isEmpty || _newPasswordRepeatController.text.isEmpty) {
                        _errorMessageNotifier.value = "Bitte fülle alle Felder aus.";
                        return;
                      }
                      if (_newPasswordController.text != _newPasswordRepeatController.text) {
                        _errorMessageNotifier.value = "Die Passwörter stimmen nicht überein.";
                      }
                      updatePassword(
                          _oldPasswordController.text,
                          _newPasswordController.text
                      );
                    },
                    child: const Text("Passwort ändern"),
                  ),
                ],
            ),
          ),
        ));
  }
}
