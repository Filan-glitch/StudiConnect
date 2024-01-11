/// This library contains the message controller.
///
/// {@category CONTROLLERS}
library controllers.messages;

import 'package:oktoast/oktoast.dart';
import 'package:studiconnect/controllers/api.dart';
import 'package:studiconnect/main.dart';
import 'package:studiconnect/models/message.dart';
import 'package:studiconnect/models/redux/actions.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/models/user.dart';
import 'package:studiconnect/services/graphql/errors/api_exception.dart';
import 'package:studiconnect/services/graphql/messages.dart' as service;
import 'package:studiconnect/services/logger_provider.dart';
import 'package:studiconnect/services/websocket/messages.dart' as websocket;
import 'package:web_socket_channel/web_socket_channel.dart';

/// Fetches messages for a specific group.
///
/// This function sends a GraphQL query to fetch messages for a specific group.
///
/// Returns a [Future] that completes with the number of messages fetched.
Future<int> getMessages(String groupID, int page, bool replace) async {
  log('Calling API to get messages');
  final List<Message>? result = await runApiService(
    apiCall: () => service.getMessages(groupID, page),
    parser: (result) {
      return (result['messages'] as List<dynamic>)
          .map((e) => Message.fromApi(e))
          .toList();
    },
  );

  if (result == null) {
    logWarning('Failed to get messages');
    store.dispatch(
      Action(
        ActionTypes.updateSessionID,
        payload: null,
      ),
    );

    navigatorKey.currentState!.pushNamedAndRemoveUntil(
      '/welcome',
      (route) => false,
    );
    return 0;
  }
  log('Updating messages in store');

  final User user = store.state.user!;

  if (replace) {
    user.groups = user.groups!
        .map(
          (group) =>
              group.id == groupID ? group.update(messages: result) : group,
        )
        .toList();
  } else {
    user.groups = user.groups!
        .map(
          (group) => group.id == groupID
              ? group.update(messages: [...group.messages!, ...result])
              : group,
        )
        .toList();
  }

  store.dispatch(
    Action(
      ActionTypes.setUser,
      payload: user,
    ),
  );

  log('Successfully updated messages');
  return result.length;
}

/// Sends a message to a specific group.
///
/// This function sends a GraphQL mutation to send a message to a specific group.
///
/// Returns a [Future] that completes with a boolean indicating whether the message was sent successfully.
Future<bool> sendMessage(String groupID, String content) async {
  try {
    log('Calling API to send message');
    await runApiService(
      apiCall: () => service.sendMessage(groupID, content),
      showLoading: false,
      shouldRethrow: true,
    );
    log('Message sent successfully');
  } on ApiException {
    //TODO: Auf unterschiedliche Fehler passend reagieren
    showToast('Nachricht konnte nicht gesendet werden. Versuche es erneut.');
    return false;
  }

  return true;
}

/// Subscribes to messages for a specific group.
///
/// This function opens a WebSocket connection to receive messages for a specific group.
///
/// Returns a [Future] that completes with a [WebSocketSink] representing the WebSocket connection.
Future<WebSocketSink?> subscribeToMessages(
    String groupID, void Function() onMessage) async {
  log('Subsribing to $groupID');
  final WebSocketSink? sink = await websocket.subscribeToMessages(groupID, (data) {
    final Message message = Message.fromApi(data);

    log('New message: ${message.content}');

    final User user = store.state.user!;
    user.groups = user.groups!
        .map(
          (group) => group.id == groupID
              ? group.update(messages: [message, ...group.messages!])
              : group,
        )
        .toList();

    store.dispatch(
      Action(
        ActionTypes.setUser,
        payload: user,
      ),
    );

    onMessage();
  });

  return sink;
}
