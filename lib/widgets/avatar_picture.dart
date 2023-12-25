import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

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
      progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress, strokeWidth: widget.loadingCircleStrokeWidth ?? 4.0),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}