import 'package:flutter/material.dart';

import '../constants.dart';
import '../controllers/groups.dart';
import '../models/group.dart';
import '../models/user.dart';

class JoinGroupRequestListItem extends StatefulWidget {
  const JoinGroupRequestListItem(
      {super.key, required this.user, required this.group});

  final User user;
  final Group group;

  @override
  State<JoinGroupRequestListItem> createState() =>
      _JoinGroupRequestListItemState();
}

class _JoinGroupRequestListItemState extends State<JoinGroupRequestListItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          "$backendURL/api/user/${widget.user.id}/image",
        ),
      ),
      title: Text(widget.user.username ?? "Unbekannt"),
      subtitle: Text(widget.user.university ?? ""),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              addMember(widget.group.id, widget.user.id);
            },
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              removeJoinRequest(widget.group.id, widget.user.id);
            },
          ),
        ],
      ),
      onTap: () {
        Navigator.pushNamed(context, '/user-info', arguments: widget.user);
      },
    );
  }
}
