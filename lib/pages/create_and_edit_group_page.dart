import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart' as geo;

import 'package:studiconnect/controllers/groups.dart';
import 'package:studiconnect/dialogs/select_location_dialog.dart';
import 'package:studiconnect/models/group.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';
import 'package:studiconnect/models/redux/actions.dart' as redux;
import 'package:studiconnect/models/redux/store.dart';

class CreateAndEditGroupPage extends StatefulWidget {
  const CreateAndEditGroupPage({super.key});

  static const routeName = '/create-and-edit-group';

  @override
  State<CreateAndEditGroupPage> createState() => _CreateAndEditGroupPageState();
}

class _CreateAndEditGroupPageState extends State<CreateAndEditGroupPage> {
  final TextEditingController _groupTitleController = TextEditingController();
  final TextEditingController _groupModuleController = TextEditingController();
  final TextEditingController _groupDescriptionController =
      TextEditingController();

  LatLng? _selectedLocation;
  Group? group;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      group = ModalRoute.of(context)!.settings.arguments as Group?;
      if (group != null) {
        _groupTitleController.text = group!.title ?? "";
        _groupModuleController.text = group!.module ?? "";
        _groupDescriptionController.text = group!.description ?? "";
        _selectedLocation = LatLng(group!.lat ?? 0.0, group!.lon ?? 0.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      padding: const EdgeInsets.only(top: 20.0),
      title: group?.id == null ? "Gruppe erstellen" : "Gruppe bearbeiten",
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30.0),
              child: TextField(
                controller: _groupTitleController,
                decoration: const InputDecoration(
                  labelText: "Titel",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30.0),
              child: TextField(
                controller: _groupModuleController,
                decoration: const InputDecoration(
                  labelText: "Modul",
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 30.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                                    geo.Placemark location = snapshot.data![0];
                                    return SizedBox(
                                      width: MediaQuery.of(context).size.width -
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
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30.0),
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
            // save button
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    if (group == null) {
                      createGroup(
                        _groupTitleController.text,
                        _groupDescriptionController.text,
                        _groupModuleController.text,
                        _selectedLocation?.latitude ?? 0.0,
                        _selectedLocation?.longitude ?? 0.0,
                      );

                      Navigator.of(context).pop();
                    } else {
                      updateGroup(
                        group!.id,
                        _groupTitleController.text,
                        _groupDescriptionController.text,
                        _groupModuleController.text,
                        _selectedLocation?.latitude ?? 0.0,
                        _selectedLocation?.longitude ?? 0.0,
                      );

                      var updatedGroup = group!.update(
                        title: _groupTitleController.text,
                        module: _groupModuleController.text,
                        description: _groupDescriptionController.text,
                        lat: _selectedLocation?.latitude,
                        lon: _selectedLocation?.longitude,
                      );

                      // Update the group data in store
                      store.dispatch(redux.Action(redux.ActionTypes.updateGroup,
                          payload: updatedGroup));

                      // Pop the page and pass the updated group data
                      Navigator.of(context).pop(updatedGroup);
                    }
                  },
                  child: const Text(
                    "Gruppe speichern",
                  ),
                ),
              ),
            ),
            if (group?.id != null)
              Padding(
                padding:
                    const EdgeInsets.only(left: 20, right: 20, bottom: 30.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      deleteGroup(group!.id);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/home',
                        (route) => false,
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.transparent,
                      ),
                      side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                    child: const Text(
                      "Gruppe löschen",
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
