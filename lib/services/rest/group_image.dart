import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:studiconnect/constants.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/services/rest/api.dart';

Future<void> uploadGroupImage(String id, Uint8List content) async {
  http.Response response = await http.post(
    Uri.parse("$backendURL/api/group/$id/image"),
    headers: {
      "Content-Type": "image/jpg",
      "Cookies": "session=${store.state.sessionID}",
    },
    body: content,
  );

  processHttpStatusCodes(response.statusCode);
}

Future<void> deleteGroupImage(String id) async {
  http.Response response = await http.delete(
    Uri.parse("$backendURL/api/group/$id/image"),
    headers: {
      "Cookies": "session=${store.state.sessionID}",
    },
  );

  processHttpStatusCodes(response.statusCode);
}
