import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:studiconnect/controllers/messages.dart';
import 'package:studiconnect/models/group.dart';
import 'package:studiconnect/models/redux/app_state.dart';
import 'package:studiconnect/widgets/chat_bubble.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:studiconnect/controllers/groups.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? groupID;
  WebSocketSink? sink;

  int _lastLoadedPage = 0;
  bool _finishedLoading = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      setState(() {
        groupID = ModalRoute.of(context)!.settings.arguments as String;
        subscribeToMessages(groupID!, _scrollToBottom)
            .then((value) => sink = value);
        getMessages(groupID!, 0, true).then((amount) {
          _scrollToBottom();
          _finishedLoading = amount < 20;
        });
      });
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels < 100 && !_finishedLoading) {
        _lastLoadedPage++;
        getMessages(groupID!, _lastLoadedPage, false)
            .then((amount) => _finishedLoading = amount < 20);
      }
    });
  }

  @override
  void dispose() {
    sink?.close();
    super.dispose();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
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
        final members =
            (group.members ?? []).map((member) => member.id).toList();

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
            if (members.contains(state.user?.id) &&
                group.creator?.id != state.user?.id)
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
          ],
          body: Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: group.messages?.length ?? 0,
                  itemBuilder: (context, idx) {
                    if (group.messages == null) return Container();

                    final message =
                        group.messages![group.messages!.length - idx - 1];

                    final prevMessage = idx == 0
                        ? null
                        : group.messages![group.messages!.length - idx];

                    bool isDifferentDay = message.sendAt?.year !=
                            prevMessage?.sendAt?.year ||
                        message.sendAt?.month != prevMessage?.sendAt?.month ||
                        message.sendAt?.day != prevMessage?.sendAt?.day;

                    return Column(
                      children: [
                        if (idx == 0 || isDifferentDay)
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Text(
                              DateFormat("dd.MM.yyyy")
                                  .format(message.sendAt ?? DateTime(1970)),
                            ),
                          ),
                        ChatBubble(message: message),
                      ],
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
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
                          hintStyle: TextStyle(color: Colors.white),
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
                          log(e.toString());
                        }
                        _messageController.clear();
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
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
