import 'package:flutter/material.dart';
import 'package:studiconnect/widgets/avatar_picture.dart';
import 'package:studiconnect/models/group.dart';

class GroupListItem extends StatelessWidget {
  final Group group;

  const GroupListItem({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/chat',
          arguments: group.id,
        );
      },
      leading: AvatarPicture(
        id: group.id,
        type: Type.group,
        radius: 15,
        loadingCircleStrokeWidth: 1.5,
      ),
      title: Text(group.title ?? "Gruppe ${group.id}"),
      subtitle: Text(group.description ?? "Keine Beschreibung"),
    );
  }
}
