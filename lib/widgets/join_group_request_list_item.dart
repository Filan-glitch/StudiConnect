/// This library contains the [JoinGroupRequestListItem] widget.
///
/// {@category WIDGETS}
library widgets.join_group_request_list_item;

import 'package:flutter/material.dart';
import 'package:studiconnect/constants.dart';
import 'package:studiconnect/controllers/groups.dart';
import 'package:studiconnect/models/group.dart';
import 'package:studiconnect/models/group_parameter.dart';
import 'package:studiconnect/models/user.dart';
import 'package:studiconnect/models/user_parameter.dart';

/// A widget that displays a list item for a join group request.
///
/// This widget is a stateful widget that takes a user and a group as input
/// and displays a ListTile with the user's avatar, username, university,
/// and two action buttons for accepting or rejecting the join request.
///
/// The [user] parameter is required and should be an instance of the User model.
///
/// The [group] parameter is required and should be an instance of the Group model.
class JoinGroupRequestListItem extends StatefulWidget {
  const JoinGroupRequestListItem(
      {super.key, required this.user, required this.group});

  final User user;
  final Group group;

  @override
  State<JoinGroupRequestListItem> createState() =>
      _JoinGroupRequestListItemState();
}

/// The state class for the JoinGroupRequestListItem widget.
///
/// This class builds the widget and handles the state changes.
class _JoinGroupRequestListItemState extends State<JoinGroupRequestListItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      /// The leading widget is a CircleAvatar with the user's profile picture.
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          '$backendURL/api/user/${widget.user.id}/image',
        ),
      ),
      /// The title of the ListTile is the user's username.
      /// If the user's username is null, display "Unbekannt".
      title: Text(widget.user.username ?? 'Unbekannt'),
      /// The subtitle of the ListTile is the user's university.
      /// If the user's university is null, display an empty string.
      subtitle: Text(widget.user.university ?? ''),
      /// The trailing widget is a Row with two IconButton widgets.
      /// The first IconButton has a check icon and adds the user to the group when pressed.
      /// The second IconButton has a close icon and removes the join request when pressed.
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
      /// When the ListTile is tapped, navigate to the '/user-info' route
      /// and pass the user as an argument.
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