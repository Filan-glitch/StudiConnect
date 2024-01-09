import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:share_plus/share_plus.dart';
import 'package:studiconnect/controllers/messages.dart';
import 'package:studiconnect/models/group.dart';
import 'package:studiconnect/models/redux/app_state.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:studiconnect/constants.dart';
import 'package:studiconnect/controllers/groups.dart';
import 'package:studiconnect/widgets/timestamped_chat_message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  String? groupID;
  WebSocketSink? sink;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      setState(() {
        groupID = ModalRoute.of(context)!.settings.arguments as String;
        subscribeToMessages(groupID!).then((value) => sink = value);
        getMessages(groupID!, 1);
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
        final members = (group.members ?? []).map((member) => member.id).toList();
        return PageWrapper(
          title: group.title ?? "",
          menuActions: [
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Gruppeninformationen'),
              onTap: () {
                Navigator.pushNamed(context, '/group-info', arguments: group);
              },
            ),
            if (state.user?.id == group.creator?.id)
              ListTile(
                leading: const Icon(Icons.group_add),
                title: const Text('Beitrittsanfragen'),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/join-group-requests',
                    arguments: group.id,
                  );
                },
              ),
            if (state.user?.id == group.creator?.id)
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Gruppe bearbeiten'),
                onTap: () async {
                  final updatedGroup = await Navigator.pushNamed(
                      context, '/create-and-edit-group',
                      arguments: group);

                  // If the group data is updated, update the state
                  if (updatedGroup != null) {
                    setState(() {
                      group = updatedGroup as Group;
                    });
                  }
                },
              ),
            if (members.contains(state.user?.id) && group.creator?.id != state.user?.id)
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Gruppe verlassen'),
                onTap: () {
                  leaveGroup(group.id);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/home',
                        (route) => false,
                  );
                },
              ),
            ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Studiconnect weiterempfehlen'),
                onTap: () {
                  Share.share(
                      'Schau dir StudiConnect an: https://play.google.com/store/apps/details?id=$appID');
                }),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Einstellungen'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            )
          ],
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  dragStartBehavior: DragStartBehavior.down,
                  children: (group.messages ?? [])
                    .map((message) => SizedBox(
                      width: 220,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: message.sender?.id == state.user?.id
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TimestampedChatMessage(
                        sender: message.sender?.username ?? "",
                        sentAt: "${message.sendAt?.hour ?? "??"}:${message.sendAt?.minute ?? "??"}",
                        text: message.content ?? "",
                        style: const TextStyle(
                          color: Colors.amber
                        ),
                      ),
                    ),
                  )).toList(),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: "Nachricht",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        if (_messageController.text.isEmpty) return;
                        try {
                          sendMessage(group.id, _messageController.text);
                          setState(() {});
                        } catch (e) {
                          print(e);
                        }
                        _messageController.clear();
                      },
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
