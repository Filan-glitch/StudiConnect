import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:studiconnect/constants.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/services/rest/api.dart';

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

Future<void> deleteProfileImage() async {
  http.Response response = await http.delete(
    Uri.parse("$backendURL/api/user/image"),
    headers: {
      "Cookies": "session=${store.state.sessionID}",
    },
  );

  processHttpStatusCodes(response.statusCode);
}
