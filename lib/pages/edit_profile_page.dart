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
          simpleDesign: true,
          title: "Profil bearbeiten",
          body: SingleChildScrollView(
            child: Column(
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
                    ]
                        .map((e) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5.0,
                              ),
                              child: e,
                            ))
                        .toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
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
                        icon: const Icon(Icons.done),
                        label: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: Text("Profil\nspeichern"),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.lock),
                        label: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: Text("Passwort\nändern"),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.background,
                        side: const BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Konto löschen",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
