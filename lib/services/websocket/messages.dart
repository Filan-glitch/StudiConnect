import 'dart:async';
import 'dart:convert';

import 'package:oktoast/oktoast.dart';
import 'package:studiconnect/constants.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/services/logger_provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

Future<WebSocketSink?> subscribeToMessages(
    String groupID,
    void Function(Map<String, dynamic> data) onMessage
    ) async
{
  log("Subscribing to messages with session:  '${store.state.sessionID}' and group: '$groupID'");
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
      logWarning(e.toString());
      showToast("Eine Nachricht konnte nicht empfangen werden.", dismissOtherToast: true);
    }
  });

  await channel.ready;
  if (channel.closeCode != null) {
    showToast("Neue Nachrichten können nicht empfangen werden.", dismissOtherToast: true);
    return null;
  }

  return channel.sink;
}
