import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:studiconnect/constants.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/services/logger_provider.dart';
import 'package:studiconnect/services/rest/api.dart';

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
