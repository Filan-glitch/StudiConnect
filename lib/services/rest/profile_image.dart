import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:studiconnect/constants.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/services/rest/api.dart';

Future<bool> profileImageAvailable() async {
  http.Response response = await http.get(
    Uri.parse("$backendURL/api/user/${store.state.user?.id}/image"),
    headers: {
      "Cookie": "session=${store.state.sessionID}",
    },
  );

  if (response.statusCode == 200) {
    return true;
  } else if (response.statusCode == 404) {
    return false;
  }

  processHttpStatusCodes(response.statusCode);
  return false;
}

Future<void> uploadProfileImage(Uint8List content) async {
  http.Response response = await http.post(
    Uri.parse("$backendURL/api/user/image"),
    headers: {
      "Content-Type": "image/jpg",
      "Cookie": "session=${store.state.sessionID}",
    },
    body: content,
  );

  processHttpStatusCodes(response.statusCode);
}

Future<void> deleteProfileImage() async {
  http.Response response = await http.delete(
    Uri.parse("$backendURL/api/user/image"),
    headers: {
      "Cookie": "session=${store.state.sessionID}",
    },
  );

  processHttpStatusCodes(response.statusCode);
}
