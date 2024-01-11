/// This library contains the [AvatarPicture] widget and the [Type] enum.
///
/// {@category WIDGETS}
library widgets.avatar_picture;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:studiconnect/constants.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/models/redux/actions.dart' as redux;

/// Enum for specifying the type of avatar.
enum Type {
  /// The avatar is for a user.
  user,

  /// The avatar is for a group.
  group
}

/// A widget that displays an avatar picture.
///
/// This widget is a stateful widget that takes an id, type, radius, and loadingCircleStrokeWidth as input
/// and displays an avatar picture using the CachedNetworkImage package.
class AvatarPicture extends StatefulWidget {

  /// The id of the user or group.
  final String? id;

  /// The type of the avatar.
  final Type type;

  /// The radius of the avatar.
  final double? radius;

  /// The width of the loading circle.
  final double? loadingCircleStrokeWidth;

  /// Creates an [AvatarPicture] widget.
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
    return ClipOval(
      clipper: _AvatarPictureClipper(),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: CachedNetworkImage(
        width: 2 * (widget.radius ?? 10),
        height: 2 * (widget.radius ?? 10),
        fit: BoxFit.cover,
        imageUrl: '$backendURL/api/${widget.type.name}/${widget.id}/image',
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(
                value: downloadProgress.progress,
                strokeWidth: widget.loadingCircleStrokeWidth ?? 4.0),
        errorWidget: (context, url, error) {
          if (widget.type == Type.user &&
              widget.id == store.state.user?.id &&
              store.state.profileImageAvailable) {
            store.dispatch(redux.Action(
              redux.ActionTypes.setProfileImageAvailable,
              payload: false,
            ));
          }

          return (widget.type == Type.user)
              ? CircleAvatar(
            radius: widget.radius ?? 10,
            backgroundColor: Colors.grey,
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: widget.radius ?? 10,
            ),
          )
              : CircleAvatar(
              radius: widget.radius ?? 10,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.group,
                color: Colors.white,
                size: widget.radius ?? 10,
              ));
        },
      ),
    );
  }
}

class _AvatarPictureClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );
  }

  @override
  bool shouldReclip(_AvatarPictureClipper oldClipper) => false;
}
