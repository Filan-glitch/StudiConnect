/// This library contains the CreateAndEditGroupPage widget.
///
/// {@category PAGES}
library pages.create_and_edit_group_page;

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
import 'package:studiconnect/widgets/page_wrapper.dart';

/// A StatefulWidget that allows the user to create or edit a group.
///
/// The page contains text fields for the group title, module, and description,
/// as well as a button to select the group's location.
/// If a group is passed as an argument to the page, the fields are pre-filled with the group's data.
class CreateAndEditGroupPage extends StatefulWidget {

  /// Creates a [CreateAndEditGroupPage] widget.
  const CreateAndEditGroupPage({super.key});

  @override
  State<CreateAndEditGroupPage> createState() => _CreateAndEditGroupPageState();
}

/// The state for the [CreateAndEditGroupPage] widget.
///
/// This class contains the logic for creating or editing a group.
class _CreateAndEditGroupPageState extends State<CreateAndEditGroupPage> {
  late final TextEditingController _groupTitleController;
  late final TextEditingController _groupModuleController;
  late final TextEditingController _groupDescriptionController;

  LatLng? _selectedLocation;
  GroupLookupParameters? groupParams;

  @override
  void initState() {
    super.initState();
    _groupTitleController = TextEditingController();
    _groupModuleController = TextEditingController();
    _groupDescriptionController = TextEditingController();

    Future.delayed(Duration.zero, () {
      setState(() {
        groupParams = ModalRoute.of(context)!.settings.arguments
            as GroupLookupParameters?;
        final Group? group = groupParams?.getGroup(context);
        if (group != null) {
          _groupTitleController.text = group.title ?? '';
          _groupModuleController.text = group.module ?? '';
          _groupDescriptionController.text =
              group.description ?? '';
          _selectedLocation = LatLng(
            group.lat ?? 0.0,
            group.lon ?? 0.0,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _groupTitleController.dispose();
    _groupModuleController.dispose();
    _groupDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          final Group? group = groupParams?.getGroup(context);
          return PageWrapper(
            padding: const EdgeInsets.only(top: 20.0),
            title: group?.id == null ? 'Gruppe erstellen' : 'Gruppe bearbeiten',
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
                        labelText: 'Titel',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 30.0),
                    child: TextField(
                      controller: _groupModuleController,
                      decoration: const InputDecoration(
                        labelText: 'Modul',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 30.0),
                    child: SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
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
                              builder: (context) =>
                                  SelectLocationDialog(
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
                                      'Treffpunkt auswählen',
                                      style: TextStyle(
                                        color: Theme
                                            .of(context)
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
                                          final geo.Placemark location = snapshot
                                              .data![0];
                                          return SizedBox(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width
                                                - 150,
                                            child: Text(
                                              '${location.street}\n${location
                                                  .locality}',
                                              style: TextStyle(
                                                color: Theme
                                                    .of(context)
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
                        labelText: 'Beschreibung',
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
                                    uploadGroupImage(group?.id ?? '', value);
                                  }
                                });
                              },
                              icon: const Icon(Icons.upload),
                              label: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Text('Gruppenbild hochladen'),
                              ),
                            ),
                          ),
                        if (group?.imageExists ?? false)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                deleteGroupImage(group?.id ?? '');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                Theme
                                    .of(context)
                                    .colorScheme
                                    .background,
                                side: const BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              icon: const Icon(Icons.delete_forever_outlined, color: Colors.red),
                              label: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(
                                  'Gruppenbild löschen',
                                  style: TextStyle(
                                    color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              if (group == null) {
                                final bool successful = await createGroup(
                                  _groupTitleController.text,
                                  _groupDescriptionController.text,
                                  _groupModuleController.text,
                                  _selectedLocation?.latitude ?? 0.0,
                                  _selectedLocation?.longitude ?? 0.0,
                                );

                                if (!successful) return;
                              } else {
                                final bool successful = await updateGroup(
                                  group.id,
                                  _groupTitleController.text,
                                  _groupDescriptionController.text,
                                  _groupModuleController.text,
                                  _selectedLocation?.latitude ?? 0.0,
                                  _selectedLocation?.longitude ?? 0.0,
                                );

                                if (!successful) return;

                                group.update(
                                  title: _groupTitleController.text,
                                  module: _groupModuleController.text,
                                  description: _groupDescriptionController.text,
                                  lat: _selectedLocation?.latitude,
                                  lon: _selectedLocation?.longitude,
                                );
                              }
                              navigatorKey.currentState!.pop();
                            },
                            icon: const Icon(Icons.done),
                            label: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              child: Text(
                                  'Gruppe speichern'
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50.0),
                        if (group?.id != null)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final bool successful = await deleteGroup(group!.id);

                                if (!successful) return;

                                navigatorKey.currentState!
                                    .pushNamedAndRemoveUntil(
                                  '/home',
                                      (route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                Theme
                                    .of(context)
                                    .colorScheme
                                    .background,
                                side: const BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
                              label: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(
                                  'Gruppe löschen',
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
                ],
              ),
            ),
          );
        }
    );
  }
}
