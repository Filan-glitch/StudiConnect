/// This library contains the [DeleteGroupDialog] widget.
///
/// {@category DIALOGS}
library dialogs.delete_group_dialog;

import 'package:flutter/material.dart';
import 'package:studiconnect/dialogs/dialog_wrapper.dart';
import 'package:studiconnect/controllers/groups.dart';
import 'package:studiconnect/main.dart';

/// A widget that represents a dialog for deleting a group.
///
/// This widget is a stateless widget that takes a user and a groupID as input,
/// and displays a dialog asking the user if they really want to remove the member.
class DeleteGroupDialog extends StatelessWidget {

  /// Creates a [DeleteGroupDialog] widget.
  const DeleteGroupDialog({
    required this.groupID,
    super.key,
  });

  /// The ID of the group to be deleted.
  final String groupID;

  @override
  Widget build(BuildContext context) {
    return DialogWrapper(
      children: [
        const Text('Möchtest du die Gruppe wirklich löschen?'),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                navigatorKey.currentState!.pop();
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
                final bool successful = await deleteGroup(groupID);

                if (!successful) return;

                navigatorKey.currentState!
                    .pushNamedAndRemoveUntil(
                  '/home',
                      (route) => false,
                );
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