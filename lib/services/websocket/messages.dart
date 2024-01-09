import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:oktoast/oktoast.dart';
import 'package:studiconnect/constants.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

Future<WebSocketSink?> subscribeToMessages(
    String groupID, void Function(Map<String, dynamic> data) onMessage) async {
  log(store.state.sessionID ?? "");
  WebSocketChannel channel =
      IOWebSocketChannel.connect(Uri.parse('$wsURL/socket'), headers: {
    "session": store.state.sessionID,
    "group": groupID,
  });

  channel.stream.listen((event) {
    try {
      Map<String, dynamic> data = jsonDecode(event);
      onMessage(data);
    } catch (e) {
      log(e.toString());
      showToast("Eine Nachricht konnte nicht empfangen werden.");
    }
  });

  await channel.ready;
  if (channel.closeCode != null) {
    showToast("Neue Nachrichten können nicht empfangen werden.");
    return null;
  }

  return channel.sink;
}
