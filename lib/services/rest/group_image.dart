/// This file contains functions for uploading and deleting group images.
///
/// {@category SERVICES}
library services.rest.group_image;

import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:studiconnect/constants.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/services/logger_provider.dart';
import 'package:studiconnect/services/rest/api.dart';

/// Uploads a group image.
///
/// The [id] parameter is the unique identifier for the group.
/// The [content] parameter is the image data as a byte array.
/// This function sends a POST request to the server with the image data in the body.
/// The server responds with a status code, which is processed by the [processHttpStatusCodes] function.
/// If the status code indicates an error, an exception is thrown.
/// This function does not return a value.
Future<void> uploadGroupImage(String id, Uint8List content) async {
  log('Uploading group image');
  final http.Response response = await http.post(
    Uri.parse('$backendURL/api/group/$id/image'),
    headers: {
      'Content-Type': 'image/jpg',
      'Cookie': 'session=${store.state.sessionID}',
    },
    body: content,
  );
  log('Uploaded group image');


  processHttpStatusCodes(response.statusCode);
}

/// Deletes the group image.
///
/// The [id] parameter is the unique identifier for the group.
/// This function sends a DELETE request to the server.
/// The server responds with a status code, which is processed by the [processHttpStatusCodes] function.
/// If the status code indicates an error, an exception is thrown.
/// This function does not return a value.
Future<void> deleteGroupImage(String id) async {
  log('Deleting group image');
  final http.Response response = await http.delete(
    Uri.parse('$backendURL/api/group/$id/image'),
    headers: {
      'Cookie': 'session=${store.state.sessionID}',
    },
  );
  log('Deleted group image');

  processHttpStatusCodes(response.statusCode);
}