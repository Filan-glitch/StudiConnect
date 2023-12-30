/// This library contains the FurtherRegistrationPage widget.
///
/// {@category PAGES}
library pages.further_registration_page;

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studiconnect/models/redux/app_state.dart';

/// A StatefulWidget that allows the user to provide additional registration information.
///
/// The page contains text fields for the user's name, university, and course.
class FurtherRegistrationPage extends StatefulWidget {
  const FurtherRegistrationPage({super.key});

  @override
  State<FurtherRegistrationPage> createState() =>
      _FurtherRegistrationPageState();
}

/// The state for the [FurtherRegistrationPage] widget.
///
/// This class contains the logic for handling the user's input and updating the user's profile.
class _FurtherRegistrationPageState extends State<FurtherRegistrationPage> {
  /// The controller for the name text field.
  final TextEditingController _nameController = TextEditingController();

  /// The controller for the university text field.
  final TextEditingController _universityController = TextEditingController();

  /// The controller for the course text field.
  final TextEditingController _courseController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _universityController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (BuildContext context, AppState state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Weitere Informationen',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                        constraints: BoxConstraints(
                          maxHeight: 50,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextField(
                      controller: _universityController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Universität',
                        constraints: BoxConstraints(
                          maxHeight: 50,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextField(
                      controller: _courseController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Studiengang',
                        constraints: BoxConstraints(
                          maxHeight: 50,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ButtonStyle(
                      //Button should be 5px smaller on each side than the maximum screen size in width and it should be dynamic to all screen sizes
                      minimumSize: MaterialStateProperty.all<Size>(
                          Size(MediaQuery.of(context).size.width - 20, 40)),
                      textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: GoogleFonts.roboto().fontFamily)),
                    ),
                    onPressed: () {
                      // TODO: update profile
                      Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                          (route) => false
                      );
                    },
                    child: const Text('Speichern'),
                  ),
                ],
              ),
            ),
          );
        });
  }
}