import 'package:flutter/material.dart';
import 'package:studiconnect/widgets/avatar_picture.dart';
import 'package:studiconnect/models/group.dart';

/// A widget that displays a list item for a group.
///
/// This widget is a stateless widget that takes a group as input
/// and displays a ListTile with the group's avatar, title, and description.
///
/// The [group] parameter is required and should be an instance of the Group model.
class GroupListItem extends StatelessWidget {
  final Group group;

  /// Creates a GroupListItem.
  ///
  /// The [group] parameter must not be null.
  const GroupListItem({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      /// When the ListTile is tapped, navigate to the '/group-info' route
      /// and pass the group as an argument.
      onTap: () {
        Navigator.pushNamed(
          context,
          '/group-info',
          arguments: group,
        );
      },
      /// The leading widget is an AvatarPicture of the group.
      leading: AvatarPicture(
        id: group.id,
        type: Type.group,
        radius: 15,
        loadingCircleStrokeWidth: 1.5,
      ),
      /// The title of the ListTile is the group's title.
      /// If the group's title is null, display "Gruppe ${group.id}".
      title: Text(group.title ?? "Gruppe ${group.id}"),
      /// The subtitle of the ListTile is the group's description.
      /// If the group's description is null, display "Keine Beschreibung".
      subtitle: Text(group.description ?? "Keine Beschreibung"),
    );
  }
}