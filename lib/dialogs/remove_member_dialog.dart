import 'package:flutter/material.dart';
import 'package:studiconnect/dialogs/dialog_wrapper.dart';
import 'package:studiconnect/controllers/groups.dart';
import 'package:studiconnect/main.dart';
import 'package:studiconnect/models/user.dart';

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
              onPressed: () async {
                final bool successful = await removeMember(groupID, user.id);

                if (!successful) return;

                navigatorKey.currentState!.pop();
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
