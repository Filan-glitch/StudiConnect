/// This file contains functions for uploading and deleting profile images.
///
/// {@category SERVICES}
library services.rest.profile_image;
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:studiconnect/constants.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/services/rest/api.dart';

/// Uploads a profile image for the current user.
///
/// The [content] parameter is required and represents the image data as a byte array.
/// This function sends a POST request to the server with the image data in the body.
/// The server responds with a status code, which is processed by the [processHttpStatusCodes] function.
/// If the status code indicates an error, an exception is thrown.
/// This function does not return a value.
Future<void> uploadProfileImage(Uint8List content) async {
  http.Response response = await http.post(
    Uri.parse("$backendURL/api/user/image"),
    headers: {
      "Content-Type": "image/jpg",
      "Cookies": "session=${store.state.sessionID}",
    },
    body: content,
  );

  processHttpStatusCodes(response.statusCode);
}

/// Deletes the profile image of the current user.
///
/// This function sends a DELETE request to the server.
/// The server responds with a status code, which is processed by the [processHttpStatusCodes] function.
/// If the status code indicates an error, an exception is thrown.
/// This function does not return a value.
Future<void> deleteProfileImage() async {
  http.Response response = await http.delete(
    Uri.parse("$backendURL/api/user/image"),
    headers: {
      "Cookies": "session=${store.state.sessionID}",
    },
  );

  processHttpStatusCodes(response.statusCode);
}