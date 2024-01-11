/// This library provides functions for subscribing to messages from a WebSocket server.
///
/// {@category SERVICES}
library services.websocket.messages;

import 'dart:async';
import 'dart:convert';
import 'package:oktoast/oktoast.dart';
import 'package:studiconnect/constants.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/services/logger_provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Subscribes to messages from a WebSocket server.
///
/// The [groupID] parameter is required and represents the ID of the group.
/// The [onMessage] parameter is required and is a function that is called when a message is received.
///
/// Returns a Future that completes with a WebSocketSink that can be used to send messages to the server.
/// If the connection fails, the Future completes with null.
///
/// The function logs the subscription process and shows a toast message if a message cannot be received or the connection fails.
Future<WebSocketSink?> subscribeToMessages(
  String groupID,
  void Function(Map<String, dynamic> data) onMessage,
) async {
  log("Subscribing to messages with session:  '${store.state.sessionID}' and group: '$groupID'");
  final WebSocketChannel channel =
      IOWebSocketChannel.connect(Uri.parse('$wsURL/socket'), headers: {
    'session': store.state.sessionID,
    'group': groupID,
  });

  // Listen to the stream of messages from the server.
  // When a message is received, it is decoded from JSON and passed to the [onMessage] function.
  // If a message cannot be received, a warning is logged and a toast message is shown.
  channel.stream.listen((event) {
    try {
      final Map<String, dynamic> data = jsonDecode(event);
      onMessage(data);
    } catch (e) {
      logWarning(e.toString());
      showToast('Eine Nachricht konnte nicht empfangen werden.',
          dismissOtherToast: true);
    }
  });

  await channel.ready;
  if (channel.closeCode != null) {
    showToast('Neue Nachrichten können nicht empfangen werden.',
        dismissOtherToast: true);
    return null;
  }

  return channel.sink;
}