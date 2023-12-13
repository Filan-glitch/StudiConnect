import 'package:flutter/material.dart';

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
        backgroundImage: NetworkImage(group.photoUrl),
      ),
      title: Text(group.title),
      subtitle: Text(group.description),
    );
  }
}