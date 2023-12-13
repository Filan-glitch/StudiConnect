import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart' as geo;

import '../dialogs/select_location_dialog.dart';
import '/widgets/page_wrapper.dart';

class EditGroupPage extends StatefulWidget {
  const EditGroupPage({this.groupID, super.key});

  final int? groupID;

  @override
  State<EditGroupPage> createState() => _EditGroupPageState();
}

class _EditGroupPageState extends State<EditGroupPage> {
  TextEditingController _groupTitleController = TextEditingController();
  TextEditingController _groupModuleController = TextEditingController();
  TextEditingController _groupDescriptionController = TextEditingController();

  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    // TODO: load group data if groupID is not null
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      padding: const EdgeInsets.only(top: 20.0),
      title: widget.groupID == null ? "Gruppe erstellen" : "Gruppe bearbeiten",
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
              child: Container(
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
                                    geo.Placemark location = snapshot.data![0];
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
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: save group data
                  },
                  child: const Text(
                    "Speichern",
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
