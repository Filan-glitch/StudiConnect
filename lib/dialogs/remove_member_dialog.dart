/// This library contains the [RemoveMemberDialog] widget.
///
/// {@category DIALOGS}
library dialogs.remove_member_dialog;

import 'package:flutter/material.dart';
import 'package:studiconnect/dialogs/dialog_wrapper.dart';
import 'package:studiconnect/controllers/groups.dart';
import 'package:studiconnect/main.dart';
import 'package:studiconnect/models/user.dart';

/// A widget that represents a dialog for removing a member from a group.
///
/// This widget is a stateless widget that takes a user and a groupID as input,
/// and displays a dialog asking the user if they really want to remove the member.
class RemoveMemberDialog extends StatelessWidget {

  /// Creates a [RemoveMemberDialog] widget.
  const RemoveMemberDialog({
    required this.user,
    required this.groupID,
    super.key,
  });

  /// The ID of the group from which the user is to be removed.
  final String groupID;

  /// The user that is to be removed.
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