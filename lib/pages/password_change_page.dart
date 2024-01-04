import 'package:flutter/material.dart';
import 'package:studiconnect/controllers/authentication.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';

class PasswordChangePage extends StatefulWidget {
  const PasswordChangePage({super.key});

  @override
  State<PasswordChangePage> createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPasswordRepeatController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
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
