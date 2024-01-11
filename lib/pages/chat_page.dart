import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:studiconnect/controllers/messages.dart';
import 'package:studiconnect/main.dart';
import 'package:studiconnect/models/group.dart';
import 'package:studiconnect/models/group_parameter.dart';
import 'package:studiconnect/models/menu_action.dart';
import 'package:studiconnect/models/redux/app_state.dart';
import 'package:studiconnect/services/logger_provider.dart';
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
      setState(() async {
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
    log('Scrolled to bottom');
    Future.delayed(
      const Duration(milliseconds: 100),
      () => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 50),
        curve: Curves.bounceIn,
      ),
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
          title: group.title ?? '',
          menuActions: [
            MenuAction(
              icon: Icons.info,
              title: 'Gruppeninformationen',
              onTap: () {
                navigatorKey.currentState!.pop();
                navigatorKey.currentState!.pushNamed(
                  '/group-info',
                  arguments: GroupLookupParameters(
                    groupID: group.id,
                    source: GroupSource.myGroups,
                  ),
                );
              },
            ),
            if (state.user?.id == group.creator?.id)
              MenuAction(
                icon: Icons.group_add,
                title: 'Beitrittsanfragen',
                onTap: () {
                  navigatorKey.currentState!.pop();
                  navigatorKey.currentState!.pushNamed(
                    '/join-group-requests',
                    arguments: group.id,
                  );
                },
              ),
            if (state.user?.id == group.creator?.id)
              MenuAction(
                icon: Icons.edit,
                title: 'Gruppe bearbeiten',
                onTap: () {
                  navigatorKey.currentState!.pop();
                  navigatorKey.currentState!.pushNamed(
                    '/create-and-edit-group',
                    arguments: GroupLookupParameters(
                      groupID: group.id,
                      source: GroupSource.myGroups,
                    ),
                  );
                },
              ),
            if (members.contains(state.user?.id) &&
                group.creator?.id != state.user?.id)
              MenuAction(
                icon: Icons.exit_to_app,
                title: 'Gruppe verlassen',
                onTap: () async {
                  final bool successful = await leaveGroup(group.id);

                  if (!successful) return;


                  navigatorKey.currentState!.pushNamedAndRemoveUntil(
                    '/home',
                    (route) => false,
                  );
                },
              ),
          ],
          body: Column(
            children: [
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

                    final bool isDifferentDay = message.sendAt?.year !=
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
                              DateFormat('dd.MM.yyyy')
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
                padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      child: Center(
                        child: TextField(
                          controller: _messageController,
                          cursorColor: Colors.white,
                          cursorRadius: const Radius.circular(10),
                          cursorWidth: 1,
                          cursorHeight: 25,
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          minLines: 1,
                          textInputAction: TextInputAction.newline,
                          decoration: const InputDecoration(
                            hintText: 'Nachricht',
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        if (_messageController.text.isEmpty) return;

                        final bool successful = await sendMessage(group.id, _messageController.text);

                        if (!successful) return;

                        _scrollToBottom();

                        _messageController.clear();

                        setState(() {});
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
