import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:studiconnect/constants.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/models/redux/actions.dart' as redux;

/// Enum for specifying the type of avatar.
enum Type { user, group }

/// A widget that displays an avatar picture.
///
/// This widget is a stateful widget that takes an id, type, radius, and loadingCircleStrokeWidth as input
/// and displays an avatar picture using the CachedNetworkImage package.
///
/// The [id] parameter is optional and represents the id of the user or group.
///
/// The [type] parameter is required and should be either Type.user or Type.group.
///
/// The [radius] parameter is optional and represents the radius of the avatar picture.
///
/// The [loadingCircleStrokeWidth] parameter is optional and represents the stroke width of the loading circle.
class AvatarPicture extends StatefulWidget {
  final String? id;
  final Type type;
  final double? radius;
  final double? loadingCircleStrokeWidth;

  const AvatarPicture({
    super.key,
    this.id,
    this.radius,
    required this.type,
    this.loadingCircleStrokeWidth,
  });

  @override
  State<AvatarPicture> createState() => _AvatarPictureState();
}

/// The state class for the AvatarPicture widget.
///
/// This class builds the widget and handles the state changes.
class _AvatarPictureState extends State<AvatarPicture> {
  @override
  Widget build(BuildContext context) {
    // If the avatar type is user and the id matches the current user id, set the profile image available in the store.
    if (widget.type == Type.user && widget.id == store.state.user?.id) {
      store.dispatch(redux.Action(
        redux.ActionTypes.setProfileImageAvailable,
        payload: true,
      ));
    }

    // Return a CachedNetworkImage widget that displays the avatar picture.
    return CachedNetworkImage(
      width: 2 * (widget.radius ?? 10),
      height: 2 * (widget.radius ?? 10),
      fit: BoxFit.cover,
      imageUrl: "$backendURL/api/${widget.type.name}/${widget.id}/image",
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(
              value: downloadProgress.progress,
              strokeWidth: widget.loadingCircleStrokeWidth ?? 4.0
          ),
      errorWidget: (context, url, error) {
        // If the avatar type is user and the id matches the current user id, set the profile image unavailable in the store.
        if (widget.type == Type.user && widget.id == store.state.user?.id) {
          store.dispatch(redux.Action(
            redux.ActionTypes.setProfileImageAvailable,
            payload: false,
          ));
        }

        // Return a CircleAvatar widget with an appropriate icon based on the avatar type.
        return (widget.type == Type.user) ? CircleAvatar(
          radius: widget.radius ?? 10,
          backgroundColor: Colors.grey,
          child: Icon(
            Icons.person,
            color: Colors.white,
            size: widget.radius ?? 10,
          ),
        ) :
        CircleAvatar(
          radius: widget.radius ?? 10,
          backgroundColor: Colors.grey,
          child: Icon(
          Icons.group,
          color: Colors.white,
          size: widget.radius ?? 10,
          )
        );
      },
    );
  }
}