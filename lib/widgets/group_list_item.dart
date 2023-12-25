import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/group.dart';

class GroupListItem extends StatelessWidget {
  final Group group;

  const GroupListItem({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/group-info',
          arguments: group,
        );
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage("$backendURL/api/groups/${group.id}/image"),
      ),
      title: Text(group.title ?? "Gruppe ${group.id}"),
      subtitle: Text(group.description ?? "Keine Beschreibung"),
    );
  }
}
