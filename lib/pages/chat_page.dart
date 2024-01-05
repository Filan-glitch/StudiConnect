import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:studiconnect/controllers/messages.dart';
import 'package:studiconnect/models/group.dart';
import 'package:studiconnect/models/redux/app_state.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String? groupID;
  WebSocketSink? sink;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      setState(() {
        groupID = ModalRoute.of(context)!.settings.arguments as String;
        subscribeToMessages(groupID!).then((value) => sink = value);
        getMessages(groupID!);
      });
    });
  }

  @override
  void dispose() {
    sink?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        Group group;
        try {
          group = (state.user?.groups ?? [])
              .firstWhere((group) => group.id == groupID);
        } catch (e) {
          return Container();
        }
        return PageWrapper(
          title: group.title ?? "",
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                sendMessage(groupID!, "Hello");
              },
              child: const Text(
                "Send",
              ),
            ),
          ),
        );
      },
    );
  }
}
