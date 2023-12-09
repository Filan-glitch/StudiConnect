import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/redux/actions.dart' as redux;
import '../models/redux/app_state.dart';
import '../models/redux/store.dart';
import '/widgets/page_wrapper.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePage();
}

class _EditProfilePage extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? course;
  String? university;
  String? bio;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return PageWrapper(
          title: "Profil bearbeiten",
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Name",
                      ),

                      initialValue: state.user?.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Bitte gib einen Namen ein";
                        }
                        return null;
                      },
                      onChanged: (value) => name = value,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Studiengang",
                      ),
                      initialValue: state.user?.course,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Bitte gib einen Studiengang ein";
                        }
                        return null;
                      },
                      onChanged: (value) => course = value,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Universität",
                      ),
                      initialValue: state.user?.university,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Bitte gib eine Universität ein";
                        }
                        return null;
                      },
                      onChanged: (value) => university = value,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Über mich",
                      ),
                      initialValue: state.user?.bio,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Bitte gib etwas über dich ein";
                        }
                        return null;
                      },
                      onChanged: (value) => bio = value,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          store.dispatch(
                            redux.Action(
                              redux.ActionTypes.updateUser,
                              payload: {
                                "name": name,
                                "course": course,
                                "university": university,
                                "bio": bio,
                              },
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Profil speichern"),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text("Passwort ändern"),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text("Konto löschen"),
                    ),
                  ),
                ],
              ),
            ],
          ),
          simpleDesign: true,
        );
      },
    );
  }
}