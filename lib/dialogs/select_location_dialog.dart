import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import 'dialog_wrapper.dart';

class SelectLocationDialog extends StatefulWidget {
  const SelectLocationDialog({required this.onLocationSelected, super.key});

  final void Function(LatLng location) onLocationSelected;

  @override
  State<SelectLocationDialog> createState() => _SelectLocationDialogState();
}

class _SelectLocationDialogState extends State<SelectLocationDialog> {
  LatLng? _selectedLocation;
  LatLng? _currentLocation;
  late Location location;

  late StreamSubscription _locationSubscription;

  @override
  void initState() {
    super.initState();

    setupLocation();
  }

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
            widget.onLocationSelected(_selectedLocation!);
          },
          child: Text(
            "Position verwenden",
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
