import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:studiconnect/constants.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/models/redux/actions.dart' as redux;

enum Type { user, group }

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

class _AvatarPictureState extends State<AvatarPicture> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: 2 * (widget.radius ?? 10),
      height: 2 * (widget.radius ?? 10),
      fit: BoxFit.cover,
      imageUrl: "$backendURL/api/${widget.type.name}/${widget.id}/image",
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
    );
  }
}
