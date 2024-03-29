/// This library contains the [DialogWrapper] widget.
///
/// {@category DIALOGS}
library dialogs.dialog_wrapper;

import 'dart:ui';
import 'package:flutter/material.dart';

/// A widget that wraps a dialog with a blurred background.
///
/// This widget is a stateless widget that takes a title and a list of child widgets as input,
/// and displays them in a dialog with a blurred background.
class DialogWrapper extends StatelessWidget {

  /// Creates a [DialogWrapper] widget.
  const DialogWrapper({
    this.title = 'Stundenplan',
    this.children,
    this.isDefaultDialog = true,
    super.key,
  });

  /// The title that will be displayed at the top of the dialog.
  final String title;

  /// The list of widgets that will be displayed in the dialog.
  final List<Widget>? children;

  /// A flag that determines whether the dialog is a default dialog.
  final bool isDefaultDialog;

  @override
  Widget build(BuildContext context) {
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