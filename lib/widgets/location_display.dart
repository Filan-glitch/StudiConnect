import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:studiconnect/services/logger_provider.dart';

class LocationDisplay extends StatefulWidget {
  final LatLng? position;
  final bool? serviceEnabled;
  final LocationPermission? permission;

  const LocationDisplay({super.key, required this.position, this.serviceEnabled, this.permission});

  @override
  State<LocationDisplay> createState() => _LocationDisplayState();
}

class _LocationDisplayState extends State<LocationDisplay> {
  String? _address;
  String? _error;

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
          '${place.street ?? ''}, ${place.postalCode ?? ''} ${place.locality ?? ''}';
        });
      }
    } catch (e) {
      logWarning(e.toString());
      setState(() {
        _address = 'Keine Adresse gefunden';
      });
    }
  }

  void _errorMessage() {
    if (widget.serviceEnabled != null) {
      if (!widget.serviceEnabled!) {
        setState(() {
          _error = 'Standortdienste sind deaktiviert';
        });
      }
      else if (widget.permission == LocationPermission.denied) {
        setState(() {
          _error = 'Standortberechtigung wiederholt verweigert';
        });
      }
      else if (widget.permission == LocationPermission.deniedForever) {
        setState(() {
          _error = 'Standortberechtigung verweigert, bitte in den Einstellungen ändern';
        });
      }
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
    return Row(
      children: [
        Icon(
          Icons.location_on,
          color: Theme.of(context).textTheme.bodySmall?.color,
          size: 16.0,
        ),
        Text(
          _error ?? _address ?? 'Adresse wird geladen...',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodySmall?.color,
            fontSize: 16.0,
          ),
        )
      ]
    );
  }
}
