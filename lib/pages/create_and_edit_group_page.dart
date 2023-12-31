import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:studiconnect/controllers/groups.dart';
import 'package:studiconnect/dialogs/select_location_dialog.dart';
import 'package:studiconnect/main.dart';
import 'package:studiconnect/models/group.dart';
import 'package:studiconnect/models/group_parameter.dart';
import 'package:studiconnect/models/redux/app_state.dart';
import 'package:studiconnect/services/logger_provider.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';

class CreateAndEditGroupPage extends StatefulWidget {
  const CreateAndEditGroupPage({super.key});

  @override
  State<CreateAndEditGroupPage> createState() => _CreateAndEditGroupPageState();
}

class _CreateAndEditGroupPageState extends State<CreateAndEditGroupPage> {
  late final TextEditingController _groupTitleController;
  late final TextEditingController _groupModuleController;
  late final TextEditingController _groupDescriptionController;

  LatLng? _selectedLocation;
  GroupLookupParameters? groupParams;

  @override
  void initState() {
    log("Initializing CreateAndEditGroupPage...");
    super.initState();
    _groupTitleController = TextEditingController();
    _groupModuleController = TextEditingController();
    _groupDescriptionController = TextEditingController();

    Future.delayed(Duration.zero, () {
      setState(() {
        groupParams = ModalRoute.of(context)!.settings.arguments
            as GroupLookupParameters?;
        if (groupParams?.group != null) {
          _groupTitleController.text = groupParams!.group!.title ?? "";
          _groupModuleController.text = groupParams!.group!.module ?? "";
          _groupDescriptionController.text =
              groupParams!.group!.description ?? "";
          _selectedLocation = LatLng(
            groupParams!.group!.lat ?? 0.0,
            groupParams!.group!.lon ?? 0.0,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    log("Disposing CreateAndEditGroupPage...");
    _groupTitleController.dispose();
    _groupModuleController.dispose();
    _groupDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("Building CreateAndEditGroupPage...");
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          Group? group = groupParams?.group;
          return PageWrapper(
            padding: const EdgeInsets.only(top: 20.0),
            title: group?.id == null ? "Gruppe erstellen" : "Gruppe bearbeiten",
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 30.0),
                    child: TextField(
                      controller: _groupTitleController,
                      decoration: const InputDecoration(
                        labelText: "Titel",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 30.0),
                    child: TextField(
                      controller: _groupModuleController,
                      decoration: const InputDecoration(
                        labelText: "Modul",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 30.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
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
                                  if (_selectedLocation == null)
                                    Text(
                                      "Treffpunkt auswählen",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.color,
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
                                          return SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                150,
                                            child: Text(
                                              '${location.street}\n${location.locality}',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.color,
                                                fontSize: 16.0,
                                              ),
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
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 30.0),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 5,
                      maxLines: null,
                      controller: _groupDescriptionController,
                      decoration: const InputDecoration(
                        labelText: "Beschreibung",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      children: [
                        // save button
                        if (group?.id != null)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                final ImagePicker picker = ImagePicker();
                                picker
                                    .pickImage(source: ImageSource.gallery)
                                    .then((value) {
                                  if (value != null) {
                                    uploadGroupImage(group?.id ?? "", value);
                                  }
                                });
                              },
                              icon: const Icon(Icons.upload),
                              label: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Text("Gruppenbild hochladen"),
                              ),
                            ),
                          ),
                        if (group?.imageExists ?? false)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                deleteGroupImage(group?.id ?? "");
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
                                child: Text("Bild löschen"),
                              ),
                            ),
                          ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              if (group == null) {
                                await createGroup(
                                  _groupTitleController.text,
                                  _groupDescriptionController.text,
                                  _groupModuleController.text,
                                  _selectedLocation?.latitude ?? 0.0,
                                  _selectedLocation?.longitude ?? 0.0,
                                );
                              } else {
                                await updateGroup(
                                  group.id,
                                  _groupTitleController.text,
                                  _groupDescriptionController.text,
                                  _groupModuleController.text,
                                  _selectedLocation?.latitude ?? 0.0,
                                  _selectedLocation?.longitude ?? 0.0,
                                );
                              }
                              navigatorKey.currentState!.pop();
                            },
                            icon: const Icon(Icons.done),
                            label: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              child: Text("Gruppe speichern"),
                            ),
                          ),
                        ),
                        if (group?.id != null)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                deleteGroup(group!.id);
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/home',
                                  (route) => false,
                                );
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
                                child: Text(
                                  "Gruppe löschen",
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
