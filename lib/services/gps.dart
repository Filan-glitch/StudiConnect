import 'package:geolocator/geolocator.dart';
import 'package:studiconnect/services/logger_provider.dart';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> determinePosition() async {
  log('Determining GPS position');
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  log('Checking if location services are enabled');
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    log('Location services are disabled');
    return Future.error('Location services are disabled.');
  }
  log('Location services are enabled');

  log('Checking location permissions');
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    log('Location permissions are denied, requesting permissions');
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      log('Location permissions are denied again');
      return Future.error('Location permissions are denied');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    log('Location permissions are permanently denied');
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  if (permission == LocationPermission.unableToDetermine) {
    // Permissions are unable to determine, handle appropriately.
    log('Location permissions are unable to determine');
    return Future.error(
        'Location permissions are unable to determine, we cannot request permissions.');
  }
  log('Location permissions are granted');

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  log('Getting current position');
  final position = await Geolocator.getCurrentPosition();
  log('Got current position: $position');
  return position;
}