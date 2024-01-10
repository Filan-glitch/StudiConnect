import 'package:studiconnect/models/group.dart';
import 'package:studiconnect/models/user.dart';

class Message {
  final String id;
  String? content;
  final User? sender;
  final Group? group;
  final DateTime? sendAt;

  Message({
    required this.id,
    this.content,
    this.sender,
    this.group,
    this.sendAt,
  });

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
