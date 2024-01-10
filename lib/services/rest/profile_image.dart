import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:studiconnect/constants.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/services/logger_provider.dart';
import 'package:studiconnect/services/rest/api.dart';

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
