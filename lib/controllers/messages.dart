import 'dart:developer';

import 'package:studiconnect/controllers/api.dart';
import 'package:studiconnect/models/message.dart';
import 'package:studiconnect/models/redux/actions.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/models/user.dart';
import 'package:studiconnect/services/graphql/messages.dart' as service;
import 'package:studiconnect/services/websocket/messages.dart' as websocket;
import 'package:web_socket_channel/web_socket_channel.dart';

Future<int> getMessages(String groupID, int page, bool replace) async {
  log("load");
  List<Message>? result = await runApiService(
    apiCall: () => service.getMessages(groupID, page),
    parser: (result) {
      return (result["messages"] as List<dynamic>)
          .map((e) => Message.fromApi(e))
          .toList();
    },
  );

  if (result == null) {
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
    return 0;
  }

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

  return result.length;
}

Future<void> sendMessage(String groupID, String content) async {
  await runApiService(
    apiCall: () => service.sendMessage(groupID, content),
    parser: (result) => null,
    showLoading: false,
  );
}

Future<WebSocketSink?> subscribeToMessages(
    String groupID, void Function() onMessage) async {
  log("sub $groupID");
  WebSocketSink? sink = await websocket.subscribeToMessages(groupID, (data) {
    Message message = Message.fromApi(data);

    log("new message: ${message.content}");

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
