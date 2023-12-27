import 'package:flutter/material.dart';

class AvatarNetworkIcon extends StatelessWidget {
  const AvatarNetworkIcon({
    required this.url,
    this.fallbackIcon,
    this.size,
    super.key,
  });

  final String url;
  final IconData? fallbackIcon;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? 100,
      height: size ?? 100,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Color.lerp(
          Theme.of(context).colorScheme.primary,
          Theme.of(context).scaffoldBackgroundColor,
          0.8,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          return Center(
            child: SizedBox(
              width: (size ?? 100) * 0.4,
              height: (size ?? 100) * 0.4,
              child: CircularProgressIndicator(
                color: Theme.of(context).brightness == Brightness.light
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            fallbackIcon ?? Icons.person,
            size: (size ?? 100) * 0.7,
            color: Theme.of(context).brightness == Brightness.light
                ? Theme.of(context).colorScheme.primary
                : Colors.white,
          );
        },
      ),
    );
  }
}
