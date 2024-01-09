import 'package:flutter/material.dart';

import 'package:studiconnect/constants.dart';
import 'package:studiconnect/controllers/groups.dart';
import 'package:studiconnect/models/group.dart';
import 'package:studiconnect/models/group_parameter.dart';
import 'package:studiconnect/models/user.dart';
import 'package:studiconnect/models/user_parameter.dart';
import 'package:studiconnect/services/logger_provider.dart';

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
  void initState() {
    log("Initializing JoinGroupRequestListItem...");
    super.initState();
  }

  @override
  void dispose() {
    log("Disposing JoinGroupRequestListItem...");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("Building JoinGroupRequestListItem...");
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
        Navigator.pushNamed(
          context,
          '/user-info',
          arguments: UserLookupParameters(
            userID: widget.user.id,
            source: UserSource.joinGroupRequest,
            groupLookupParameters: GroupLookupParameters(
              groupID: widget.group.id,
              source: GroupSource.myGroups,
            ),
          ),
        );
      },
    );
  }
}
