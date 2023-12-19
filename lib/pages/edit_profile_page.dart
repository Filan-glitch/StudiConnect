import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:latlong2/latlong.dart';

import '../dialogs/select_location_dialog.dart';
import '../models/redux/actions.dart' as redux;
import '../models/redux/app_state.dart';
import '../models/redux/store.dart';
import '/widgets/page_wrapper.dart';
import 'package:geocoding/geocoding.dart' as geo;

// TODO: upload profile image
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePage();
}

class _EditProfilePage extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? username;
  String? major;
  String? university;
  String? mobile;
  String? discord;
  String? bio;
  LatLng? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return PageWrapper(
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
                        initialValue: state.user?.username,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Bitte gib einen Namen ein";
                          }
                          return null;
                        },
                        onChanged: (value) => username = value,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Studiengang",
                        ),
                        initialValue: state.user?.major,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Bitte gib einen Studiengang ein";
                          }
                          return null;
                        },
                        onChanged: (value) => major = value,
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
                        keyboardType: TextInputType.multiline,
                        minLines: 5,
                        maxLines: null,
                        decoration: const InputDecoration(
                          labelText: "Über mich",
                          border: OutlineInputBorder(),
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
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Telefonnummer",
                        ),
                        initialValue: state.user?.mobile,
                        validator: (value) => null,
                        onChanged: (value) => mobile = value,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Discord",
                        ),
                        initialValue: state.user?.discord,
                        validator: (value) => null,
                        onChanged: (value) => discord = value,
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
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 30.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => SelectLocationDialog(
                              onLocationSelected: (location) {
                                setState(() {
                                  _selectedLocation = location;
                                });

                                Navigator.of(context).pop();
                              },
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 20.0),
                              child: Icon(Icons.location_on),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Treffpunkt auswählen",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                ),
                                if (_selectedLocation != null)
                                  FutureBuilder(
                                    future: geo.placemarkFromCoordinates(
                                      _selectedLocation!.latitude,
                                      _selectedLocation!.longitude,
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        geo.Placemark location =
                                            snapshot.data![0];
                                        return Text(
                                          '${location.street} ${location.locality}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                              ],
                            ),
                          ],
                        )),
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
                                  "username": username,
                                  "major": major,
                                  "university": university,
                                  "bio": bio,
                                  "mobile": mobile,
                                  "discord": discord,
                                  "lat": _selectedLocation?.latitude,
                                  "lon": _selectedLocation?.longitude,
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
                        backgroundColor: Colors.white,
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
