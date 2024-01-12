/// This library contains the [SelectLocationDialog] widget.
///
/// {@category DIALOGS}
library dialogs.select_location_dialog;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:oktoast/oktoast.dart';
import 'package:studiconnect/dialogs/dialog_wrapper.dart';

/// A widget that represents a dialog for selecting a location on a map.
///
/// This widget is a stateful widget that takes a function as input,
/// which is called when a location is selected on the map.
///
/// The [onLocationSelected] parameter is required and represents the function
/// that is called when a location is selected on the map.
class SelectLocationDialog extends StatefulWidget {
  /// The const constructor of the [SelectLocationDialog] widget.
  const SelectLocationDialog({required this.onLocationSelected, super.key});

  /// The function that is called when a location is selected on the map.
  final void Function(LatLng location) onLocationSelected;

  @override
  State<SelectLocationDialog> createState() => _SelectLocationDialogState();
}

/// The state for the [SelectLocationDialog] widget.
///
/// This class defines the state for the [SelectLocationDialog] widget. It includes
/// the selected location, the current location, and the location service.
class _SelectLocationDialogState extends State<SelectLocationDialog> {
  LatLng? _selectedLocation;
  LatLng? _currentLocation;
  late Location location;

  late final StreamSubscription<LocationData> _locationSubscription;

  /// Sets up the location service.
  ///
  /// This method initializes the location service and requests the necessary permissions.
  /// It also starts listening for location updates.
  void setupLocation() async {
    location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationSubscription =
        location.onLocationChanged.listen((LocationData currentLocation) async {
          setState(() {
            _currentLocation = LatLng(
              currentLocation.latitude!,
              currentLocation.longitude!,
            );
          });
        });
  }

  @override
  void initState() {
    super.initState();

    setupLocation();
  }

  @override
  void dispose() {
    _locationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DialogWrapper(
      isDefaultDialog: false,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.95,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: const LatLng(51.163361, 10.447683),
                initialZoom: 5.5,
                onTap: (tapPosition, point) {
                  setState(() {
                    _selectedLocation = point;
                  });
                },
              ),
              children: [
                TileLayer(
                  // x->x-axis, y->y-axis, z->zoom
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayer(
                  markers: [
                    if (_currentLocation != null)
                      Marker(
                        point: _currentLocation!,
                        width: 200,
                        height: 200,
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.blue,
                          size: 50,
                        ),
                      ),
                    if (_selectedLocation != null)
                      Marker(
                        point: _selectedLocation!,
                        width: 200,
                        height: 200,
                        child: const Padding(
                          padding: EdgeInsets.only(bottom: 50.0),
                          child: Icon(
                            Icons.location_on_outlined,
                            color: Colors.deepPurple,
                            size: 80,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
          ),
          onPressed: () {
            if(_selectedLocation != null) {
              widget.onLocationSelected(_selectedLocation!);
            } else if (_currentLocation != null) {
              widget.onLocationSelected(_currentLocation!);
            } else {
              showToast('Keine Position ausgewählt');
            }
          },
          child: Text(
            'Position verwenden',
            style: TextStyle(
              color: Theme.of(context).textTheme.labelSmall?.color,
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    );
  }
}