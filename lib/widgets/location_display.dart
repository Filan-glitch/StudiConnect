import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;

/// A widget that displays a location's address.
///
/// This widget is a stateful widget that takes a latitude and longitude as input
/// and displays the corresponding address using the geocoding package.
///
/// The [lat] and [lon] parameters are required and represent the latitude and longitude of the location.
class LocationDisplay extends StatefulWidget {
  final double lat;
  final double lon;

  /// Creates a LocationDisplay.
  ///
  /// The [lat] and [lon] parameters must not be null.
  const LocationDisplay({super.key, required this.lat, required this.lon});

  @override
  State<LocationDisplay> createState() => _LocationDisplayState();
}

/// The state class for the LocationDisplay widget.
///
/// This class builds the widget and handles the state changes.
class _LocationDisplayState extends State<LocationDisplay> {
  String? _address;

  @override
  void initState() {
    super.initState();
    _getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      /// The text of the Text widget is the address of the location.
      /// If the address is null, display 'Adresse wird geladen...'.
      _address ?? 'Adresse wird geladen...',
      style: TextStyle(
        color: Theme.of(context).textTheme.bodySmall?.color,
        fontSize: 16.0,
      ),
    );
  }

  /// A method that gets the address of the location using the geocoding package.
  Future<void> _getAddress() async {
    try {
      final List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
          widget.lat, widget.lon);
      final geo.Placemark place = placemarks[0];
      setState(() {
        _address = '${place.street ?? ""}, ${place.postalCode ?? ""} ${place.locality ?? ""}';
      });
    } catch (e) {
      setState(() {
        _address = 'Keine Adresse gefunden';
      });
    }
  }
}