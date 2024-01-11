/// This library contains the Message model.
///
/// {@category MODELS}
library models.message;

import 'package:studiconnect/models/group.dart';
import 'package:studiconnect/models/user.dart';

/// Represents a message.
///
/// This class is used to define a message with an id, content, sender, group, and sendAt.
class Message {

  /// The id of the message.
  final String id;

  /// The content of the message.
  String? content;

  /// The sender of the message.
  final User? sender;

  /// The group where the message was sent.
  final Group? group;

  /// The time when the message was sent.
  final DateTime? sendAt;

  /// Creates a [Message].
  ///
  /// The [id] parameter must not be null.
  Message({
    required this.id,
    this.content,
    this.sender,
    this.group,
    this.sendAt,
  });

  /// Creates a [Message] from a map.
  ///
  /// The [data] parameter must not be null and represents the map from which the message will be created.
  /// The map must contain the 'id' key. The 'content', 'sender', 'group', and 'sendAt' keys are optional.
  factory Message.fromApi(Map<String, dynamic> data) {
    return Message(
      id: data['id'],
      content: data['content'],
      sender: data.containsKey('sender') ? User.fromApi(data['sender']) : null,
      group: data.containsKey('group') ? Group.fromApi(data['group']) : null,
      sendAt:
          data.containsKey('sendAt') ? DateTime.parse(data['sendAt']) : null,
    );
  }
}