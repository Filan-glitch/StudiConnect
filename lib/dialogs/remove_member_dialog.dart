import 'package:flutter/material.dart';
import 'package:studiconnect/dialogs/dialog_wrapper.dart';

import '../controllers/groups.dart';
import '../models/user.dart';

class RemoveMemberDialog extends StatelessWidget {
  const RemoveMemberDialog({
    required this.user,
    required this.groupID,
    super.key,
  });

  final String groupID;
  final User user;

  @override
  Widget build(BuildContext context) {
    return DialogWrapper(
      children: [
        Text('Möchtest du ${user.username} wirklich entfernen?'),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Abbrechen',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                removeMember(groupID, user.id);
                Navigator.of(context).pop();
              },
              child: Text(
                'Entfernen',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
