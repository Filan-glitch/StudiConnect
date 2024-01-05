import 'dart:developer';

import 'package:studiconnect/controllers/api.dart';
import 'package:studiconnect/models/message.dart';
import 'package:studiconnect/models/redux/actions.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/models/user.dart';
import 'package:studiconnect/services/graphql/messages.dart' as service;
import 'package:studiconnect/services/websocket/messages.dart' as websocket;
import 'package:web_socket_channel/web_socket_channel.dart';

Future<void> getMessages(String groupID) async {
  List<Message>? result = await runApiService(
    apiCall: () => service.getMessages(groupID),
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
  }

  User user = store.state.user!;
  user.groups!.map(
    (group) => group.id == groupID ? group.update(messages: result) : group,
  );

  store.dispatch(
    Action(
      ActionTypes.setUser,
      payload: user,
    ),
  );
}

Future<void> sendMessage(String groupID, String content) async {
  await runApiService(
    apiCall: () => service.sendMessage(groupID, content),
    parser: (result) => null,
    showLoading: false,
  );
}

Future<WebSocketSink?> subscribeToMessages(String groupID) async {
  WebSocketSink? sink = await websocket.subscribeToMessages(groupID, (data) {
    Message message = Message.fromApi(data);

    log("new message: ${message.content}");

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
