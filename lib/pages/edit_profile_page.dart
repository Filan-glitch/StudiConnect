import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:studiconnect/main.dart';
import 'package:studiconnect/models/redux/app_state.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/services/logger_provider.dart';
import 'package:studiconnect/widgets/location_display.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';

import '../controllers/user.dart';
import '../services/gps.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePage();
}

class _EditProfilePage extends State<EditProfilePage> {
  late final GlobalKey<FormState> _formKey;
  late final UniqueKey _locationKey;
  late final TextEditingController _usernameController;
  late final TextEditingController _majorController;
  late final TextEditingController _universityController;
  late final TextEditingController _bioController;
  late final TextEditingController _mobileController;
  late final TextEditingController _discordController;

  LatLng? _selectedLocation;
  bool? _serviceEnabled;
  LocationPermission? _permission;

  @override
  void initState() {
    log("Iniatilizing EditProfilePage...");
    super.initState();
    _usernameController = TextEditingController.fromValue(
      TextEditingValue(
        text: store.state.user?.username ?? "",
      ),
    );
    _majorController = TextEditingController.fromValue(
      TextEditingValue(
        text: store.state.user?.major ?? "",
      ),
    );
    _universityController = TextEditingController.fromValue(
      TextEditingValue(
        text: store.state.user?.university ?? "",
      ),
    );
    _bioController = TextEditingController.fromValue(
      TextEditingValue(
        text: store.state.user?.bio ?? "",
      ),
    );
    _mobileController = TextEditingController.fromValue(
      TextEditingValue(
        text: store.state.user?.mobile ?? "",
      ),
    );
    _discordController = TextEditingController.fromValue(
      TextEditingValue(
        text: store.state.user?.discord ?? "",
      ),
    );
    _formKey = GlobalKey<FormState>();
    _locationKey = UniqueKey();

    determinePosition().then(
      (value) async {
        setState(() {
          _selectedLocation = LatLng(value.latitude, value.longitude);
        });
      },
      onError: (error) {
        _selectedLocation = const LatLng(0, 0);
        if (error.toString() == "Location services are disabled.") {
          setState(() {
            _serviceEnabled = false;
          });
        } else if (error.toString() == "Location permissions are denied") {
          setState(() {
            _permission = LocationPermission.denied;
          });
        } else if (error.toString() ==
            "Location permissions are permanently denied, we cannot request permissions.") {
          setState(() {
            _permission = LocationPermission.deniedForever;
          });
        } else {
          setState(() {
            _permission = LocationPermission.unableToDetermine;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    log("Disposing EditProfilePage...");
    _usernameController.dispose();
    _majorController.dispose();
    _universityController.dispose();
    _bioController.dispose();
    _mobileController.dispose();
    _discordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("Building EditProfilePage...");
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return PageWrapper(
          title: "Profil bearbeiten",
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 20,
              ),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: "Name",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Bitte gib einen Namen ein";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Studiengang",
                          ),
                          controller: _majorController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Bitte gib einen Studiengang ein";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Universität",
                          ),
                          controller: _universityController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Bitte gib eine Universität ein";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _bioController,
                          keyboardType: TextInputType.multiline,
                          minLines: 5,
                          maxLines: null,
                          decoration: const InputDecoration(
                            labelText: "Über mich",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Bitte gib etwas über dich ein";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _mobileController,
                          decoration: const InputDecoration(
                            labelText: "Telefonnummer",
                          ),
                          validator: (value) => null,
                          keyboardType: TextInputType.phone,
                        ),
                        TextFormField(
                          controller: _discordController,
                          decoration: const InputDecoration(
                            labelText: "Discord",
                          ),
                          validator: (value) => null,
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
                      top: 20.0,
                    ),
                    child: LocationDisplay(
                      key: _locationKey,
                      position: _selectedLocation ?? const LatLng(0, 0),
                      serviceEnabled: _serviceEnabled,
                      permission: _permission,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final ImagePicker picker = ImagePicker();
                              picker
                                  .pickImage(source: ImageSource.gallery)
                                  .then((value) {
                                if (value != null) {
                                  uploadProfileImage(value);
                                }
                              });
                            },
                            icon: const Icon(Icons.upload),
                            label: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              child: Text("Profilbild hochladen"),
                            ),
                          ),
                        ),
                        if (state.profileImageAvailable)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                deleteProfileImage();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                Theme.of(context).colorScheme.background,
                                side: const BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              icon: const Icon(Icons.delete),
                              label: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Text("Profilbild löschen"),
                              ),
                            ),
                          ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                updateProfile(
                                  _usernameController.text,
                                  _universityController.text,
                                  _majorController.text,
                                  _selectedLocation?.latitude ?? 0,
                                  _selectedLocation?.longitude ?? 0,
                                  _bioController.text,
                                  _mobileController.text,
                                  _discordController.text,
                                );

                                navigatorKey.currentState!.pop();
                              }
                            },
                            icon: const Icon(Icons.done),
                            label: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              child: Text("Profil speichern"),
                            ),
                          ),
                        ),
                        if (state.authProviderType == "email")
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  '/update-password',
                                );
                              },
                              icon: const Icon(Icons.lock),
                              label: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Text("Passwort ändern"),
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.background,
                              side: const BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                '/delete-account',
                              );
                            },
                            label: const Text(
                              "Konto löschen",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                            icon: const Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.red,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
