library dialogs.remove_member_dialog;
import 'package:flutter/material.dart';
import 'package:studiconnect/dialogs/dialog_wrapper.dart';
import 'package:studiconnect/controllers/groups.dart';
import 'package:studiconnect/models/user.dart';

/// A widget that represents a dialog for removing a member from a group.
///
/// This widget is a stateless widget that takes a user and a groupID as input,
/// and displays a dialog asking the user if they really want to remove the member.
///
/// The [user] parameter is required and represents the user that is to be removed.
///
/// The [groupID] parameter is required and represents the ID of the group from which the user is to be removed.
class RemoveMemberDialog extends StatelessWidget {
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