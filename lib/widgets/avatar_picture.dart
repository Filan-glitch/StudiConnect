import 'package:flutter/material.dart';

import '../constants.dart';

enum Type { user, group }

class AvatarPicture extends StatefulWidget {
  final String? id;
  final Type type;
  final double? radius;

  const AvatarPicture({
    super.key,
    this.id,
    this.radius,
    required this.type
  });

  @override
  State<AvatarPicture> createState() => _AvatarPictureState();
}

class _AvatarPictureState extends State<AvatarPicture> {
  @override
  Widget build(BuildContext context) {
    try {
      var image = NetworkImage("$backendURL/api/${widget.type.name}/${widget.id}/image");
      return CircleAvatar(
        radius: widget.radius,
        foregroundImage: image,
        backgroundColor: Colors.grey,

      );
    } catch (e) {
      return CircleAvatar(
        radius: widget.radius ?? 50.0,
        backgroundColor: Colors.grey,
      );
    }
  }
}