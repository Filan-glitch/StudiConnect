/// This file contains functions for uploading and deleting profile images.
///
/// {@category SERVICES}
library services.rest.profile_image;

import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:studiconnect/constants.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/services/logger_provider.dart';
import 'package:studiconnect/services/rest/api.dart';

/// Checks if a profile image is available for the current user.
///
/// This function sends a GET request to the server to check if a profile image is available for the current user.
/// The server responds with a status code, which is processed by this function.
/// If the status code is 200, it means that a profile image is available and the function returns true.
/// If the status code is 404, it means that a profile image is not available and the function returns false.
/// If the status code indicates another type of error, the [processHttpStatusCodes] function is called to process the error and the function returns false.
///
/// Returns a [Future] that completes with a boolean indicating whether a profile image is available or not.
Future<bool> profileImageAvailable() async {
  log('Checking if profile image is available');
  final http.Response response = await http.get(
    Uri.parse('$backendURL/api/user/${store.state.user?.id}/image'),
    headers: {
      'Cookie': 'session=${store.state.sessionID}',
    },
  );
  log('Checked if profile image is available');

  if (response.statusCode == 200) {
    log('Profile image is available');
    return true;
  } else if (response.statusCode == 404) {
    log('Profile image is not available');
    return false;
  }

  processHttpStatusCodes(response.statusCode);
  return false;
}

/// Uploads a profile image for the current user.
///
/// The [content] parameter is required and represents the image data as a byte array.
/// This function sends a POST request to the server with the image data in the body.
/// The server responds with a status code, which is processed by the [processHttpStatusCodes] function.
/// If the status code indicates an error, an exception is thrown.
/// This function does not return a value.
Future<void> uploadProfileImage(Uint8List content) async {
  log('Uploading profile image');
  final http.Response response = await http.post(
    Uri.parse('$backendURL/api/user/image'),
    headers: {
      'Content-Type': 'image/jpg',
      'Cookie': 'session=${store.state.sessionID}',
    },
    body: content,
  );
  log('Uploaded profile image');

  processHttpStatusCodes(response.statusCode);
}

/// Deletes the profile image of the current user.
///
/// This function sends a DELETE request to the server.
/// The server responds with a status code, which is processed by the [processHttpStatusCodes] function.
/// If the status code indicates an error, an exception is thrown.
/// This function does not return a value.
Future<void> deleteProfileImage() async {
  log('Deleting profile image');
  final http.Response response = await http.delete(
    Uri.parse('$backendURL/api/user/image'),
    headers: {
      'Cookie': 'session=${store.state.sessionID}',
    },
  );
  log('Deleted profile image');

  processHttpStatusCodes(response.statusCode);
}