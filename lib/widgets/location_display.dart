/// This library contains the [LocationDisplay] widget.
///
/// {@category WIDGETS}
library widgets.location_display;

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:studiconnect/dialogs/select_location_dialog.dart';
import 'package:studiconnect/main.dart';
import 'package:studiconnect/services/logger_provider.dart';

/// A widget that displays a location's address.
///
/// This widget is a stateful widget that takes a latitude and longitude as input
/// and displays the corresponding address using the geocoding package.
class LocationDisplay extends StatefulWidget {
  /// The latitude and longitude of the location.
  final LatLng? position;

  /// The location service status.
  final bool? serviceEnabled;

  /// The location permission status.
  final LocationPermission? permission;

  /// The location accuracy status.
  final LocationAccuracyStatus? accuracyStatus;

  /// The error status.
  final bool? error;

  /// Creates a [LocationDisplay].
  ///
  /// The [position] parameter must not be null.
  const LocationDisplay({super.key, required this.position, this.serviceEnabled, this.permission, this.accuracyStatus, this.error});

  @override
  State<LocationDisplay> createState() => _LocationDisplayState();
}

/// The state class for the LocationDisplay widget.
///
/// This class builds the widget and handles the state changes.
class _LocationDisplayState extends State<LocationDisplay> {
  String? _address;
  String? _error;
  LatLng? _manualPosition;

  /// A method that gets the address from the latitude and longitude.
  ///
  /// This method uses the geocoding package to get the address from the latitude and longitude.
  /// If the address is not found, it sets the address to 'Keine Adresse gefunden'.
  Future<void> _getAddress() async {
    try {
      if (widget.position != null) {
        log('Getting address for ${widget.position}');
        final List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
            widget.position!.latitude, widget.position!.longitude);
        final geo.Placemark place = placemarks[0];
        log('Got address: $place');
        setState(() {
          _address =
          '${place.street ?? ''}\n${place.postalCode ?? ''} ${place.locality ?? ''}';
        });
      }
    } catch (e) {
      logWarning(e.toString());
      setState(() {
        _address = 'Keine Adresse gefunden';
      });
    }
  }

  /// A method that sets the error message based on the location service status and permission.
  ///
  /// This method checks the location service status and permission and sets the error message accordingly.
  void _errorMessage() {
    if (widget.serviceEnabled != null) {
      if (!widget.serviceEnabled!) {
        setState(() {
          _error = 'Standortdienste sind deaktiviert.';
        });
        return;
      }
    }
    if (widget.permission == LocationPermission.denied) {
      setState(() {
        _error = 'Standortberechtigung wiederholt verweigert.';
      });
    } else if (widget.permission == LocationPermission.deniedForever) {
      setState(() {
        _error = 'Standortberechtigung permanent verweigert.';
      });
    } else if (widget.accuracyStatus != null && widget.accuracyStatus != LocationAccuracyStatus.precise) {
      setState(() {
        _error = 'Standortgenauigkeit ist nicht hoch genug.';
      });
    } else if (widget.error != null && widget.error!) {
      setState(() {
        _error = 'Standort konnte nicht ermittelt werden.';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _errorMessage();
    _getAddress();
  }

  @override
  Widget build(BuildContext context) {
    if(_error != null) {
      return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) =>
                  SelectLocationDialog(
                    onLocationSelected: (pos) {
                      setState(() {
                        _manualPosition = pos;
                      });

                      navigatorKey.currentState!.pop();
                    },
                  ),
            );
          },
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Icon(
                  Icons.location_on,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  size: 20.0,
                ),
              ),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_manualPosition == null)
                        Text(
                          '$_error Bitte klicke hier, um einen Standort auszuwählen.',
                          style: TextStyle(
                            color: Theme
                                .of(context)
                                .textTheme
                                .labelSmall
                                ?.color,
                            fontSize: 16.0,
                          ),
                        ),
                      if (_manualPosition != null)
                        FutureBuilder(
                          future: geo.placemarkFromCoordinates(
                            _manualPosition!.latitude,
                            _manualPosition!.longitude,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final geo.Placemark location = snapshot
                                  .data![0];
                              return Text(
                                '${location.street ?? ''}\n${location.postalCode ?? ''} ${location.locality ?? ''}',
                                style: TextStyle(
                                  color: Theme
                                      .of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
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
              ),
            ],
          )
      );
    }
    return Row(
      children: [
        Icon(
          Icons.location_on,
          color: Theme.of(context).textTheme.bodySmall?.color,
          size: 20.0,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            _address ?? 'Adresse wird geladen...',
            style: TextStyle(
              color: Theme
                  .of(context)
                  .textTheme
                  .bodySmall
                  ?.color,
              fontSize: 16.0,
            ),
          ),
        ),
      ]
    );
  }
}