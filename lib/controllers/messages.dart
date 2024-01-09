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

Future<int> getMessages(String groupID, int page, bool replace) async {
  log("Calling API to get messages");
  List<Message>? result = await runApiService(
    apiCall: () => service.getMessages(groupID, page),
    parser: (result) {
      return (result["messages"] as List<dynamic>)
          .map((e) => Message.fromApi(e))
          .toList();
    },
  );

  if (result == null) {
    logWarning("Failed to get messages");
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
  log("Updating messages in store");

  User user = store.state.user!;

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

  log("Successfully updated messages");
  return result.length;
}

Future<bool> sendMessage(String groupID, String content) async {
  try {
    log("Calling API to send message");
    await runApiService(
      apiCall: () => service.sendMessage(groupID, content),
      showLoading: false,
      shouldRethrow: true,
    );
    log("Message sent successfully");
  } on ApiException {
    //TODO: Auf unterschiedliche Fehler passend reagieren
    showToast("Nachricht konnte nicht gesendet werden. Versuche es erneut.");
    return false;
  }

  return true;
}

Future<WebSocketSink?> subscribeToMessages(
    String groupID, void Function() onMessage) async {
  log("Subsribing to $groupID");
  WebSocketSink? sink = await websocket.subscribeToMessages(groupID, (data) {
    Message message = Message.fromApi(data);

    log("New message: ${message.content}");

    User user = store.state.user!;
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
