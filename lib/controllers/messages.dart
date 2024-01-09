import 'package:oktoast/oktoast.dart';
import 'package:studiconnect/controllers/api.dart';
import 'package:studiconnect/models/message.dart';
import 'package:studiconnect/models/redux/actions.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/models/user.dart';
import 'package:studiconnect/services/graphql/errors/api_exception.dart';
import 'package:studiconnect/services/graphql/messages.dart' as service;
import 'package:studiconnect/services/logger_provider.dart';
import 'package:studiconnect/services/websocket/messages.dart' as websocket;
import 'package:web_socket_channel/web_socket_channel.dart';

Future<void> getMessages(String groupID, int page) async {
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
    return;
    // store.dispatch(
    //   Action(
    //     ActionTypes.updateSessionID,
    //     payload: null,
    //   ),
    // );

    // navigatorKey.currentState!.pushNamedAndRemoveUntil(
    //   '/welcome',
    //   (route) => false,
    // );
  }
  log("Updating messages in store");

  User user = store.state.user!;
  // TODO: Sollte das nicht mit store dispatch passieren? Wir verändern hier doch was im state.
  user.groups!.map(
    (group) => group.id == groupID ? group.update(messages: result) : group,
  );

  store.dispatch(
    Action(
      ActionTypes.setUser,
      payload: user,
    ),
  );
  
  log("Successfully updated messages");
}

Future<void> sendMessage(String groupID, String content) async {
  try {
    log("Calling API to send message");
    await runApiService(
      apiCall: () => service.sendMessage(groupID, content),
      parser: (result) => null,
      showLoading: false,
    );
    log("Message sent successfully");
  } on ApiException catch (e) {
    //TODO: Auf unterschiedliche Fehler passend reagieren
    showToast("Nachricht konnte nicht gesendet werden. Versuche es erneut.");
    rethrow;
  }
}

Future<WebSocketSink?> subscribeToMessages(String groupID) async {
  log("Subsribing to $groupID");
  WebSocketSink? sink = await websocket.subscribeToMessages(groupID, (data) {
    Message message = Message.fromApi(data);

    log("New message: ${message.content}");

    User user = store.state.user!;
    user.groups!.map(
      (group) => group.id == groupID
          ? group.update(messages: [...group.messages!, message])
          : group,
    );

    store.dispatch(
      Action(
        ActionTypes.setUser,
        payload: user,
      ),
    );
  });

  return sink;
}
