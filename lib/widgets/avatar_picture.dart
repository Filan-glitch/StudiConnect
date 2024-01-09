import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:studiconnect/constants.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/models/redux/actions.dart' as redux;
import 'package:studiconnect/services/logger_provider.dart';

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
  void initState() {
    log("Initializing AvatarPicture...");
    super.initState();
  }

  @override
  void dispose() {
    log("Disposing AvatarPicture...");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("Building AvatarPicture...");
    return ClipOval(
      clipper: _AvatarPictureClipper(),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: CachedNetworkImage(
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
