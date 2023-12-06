import 'package:flutter/material.dart';

import '../models/group.dart';

class GroupListItem extends StatelessWidget {
  final Group group;
  final Function()? onTap;

  const GroupListItem({super.key, required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(group.photoUrl),
      ),
      title: Text(group.name),
      subtitle: Text(group.description),
    );
  }
}