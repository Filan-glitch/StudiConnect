import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studiconnect/models/message.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/render_objects/timestamped_chat_message.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    bool isOwnMessage = message.sender?.id == store.state.user?.id;
    return Align(
      alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        padding: const EdgeInsets.all(10),
        decoration: isOwnMessage
            ? BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(0),
                ),
              )
            : BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(10),
                ),
              ),
        child: TimestampedChatMessage(
          sender: message.sender?.username ?? "",
          sentAt: DateFormat("HH:mm").format(message.sendAt ?? DateTime(1970)),
          text: message.content ?? "",
          brightness:
              isOwnMessage ? Brightness.dark : Theme.of(context).brightness,
        ),
      ),
    );
  }
}
