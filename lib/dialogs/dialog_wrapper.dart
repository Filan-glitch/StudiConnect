import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:studiconnect/services/logger_provider.dart';

class DialogWrapper extends StatelessWidget {
  const DialogWrapper({
    this.title = "Stundenplan",
    this.children,
    this.isDefaultDialog = true,
    super.key,
  });

  final bool isDefaultDialog;
  final String title;
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    log("Building DialogWrapper...");
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: SimpleDialog(
        surfaceTintColor: Theme.of(context).colorScheme.background,
        backgroundColor: Theme.of(context).colorScheme.background,
        shadowColor: const Color.fromARGB(255, 97, 97, 97),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        contentPadding: isDefaultDialog
            ? const EdgeInsets.all(25.0)
            : const EdgeInsets.all(0),
        title: isDefaultDialog
            ? Text(
                title,
                overflow: TextOverflow.fade,
                style: const TextStyle(
                  fontSize: 25.0,
                ),
              )
            : null,
        children: children,
      ),
    );
  }
}
