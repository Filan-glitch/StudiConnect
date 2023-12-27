import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;

class LocationDisplay extends StatefulWidget {
  final double lat;
  final double lon;

  const LocationDisplay({super.key, required this.lat, required this.lon});

  @override
  State<LocationDisplay> createState() => _LocationDisplayState();
}

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
      _address ?? 'Adresse wird geladen...',
      style: TextStyle(
        color: Theme.of(context).textTheme.bodySmall?.color,
        fontSize: 16.0,
      ),
    );
  }

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