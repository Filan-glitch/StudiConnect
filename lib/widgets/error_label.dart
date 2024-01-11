/// This library contains the [ErrorLabel] class.
///
/// {@category WIDGETS}
library widgets.error_label;

import 'package:flutter/material.dart';

/// A widget that displays an error message.
///
/// This widget is a stateless widget that takes an error message notifier as input
/// and displays the error message if it is not empty.
class ErrorLabel extends StatelessWidget {
  /// Creates a new error label instance.
  const ErrorLabel({super.key, required this.errorMessageNotifier});

  /// The error message notifier.
  final ValueNotifier<String> errorMessageNotifier;

  /// Builds the widget.
  ///
  /// This method builds the widget based on the current state.
  /// It returns a [ValueListenableBuilder] that listens to the [errorMessageNotifier] and
  /// builds a [Visibility] widget that shows or hides the error message based on whether it is empty or not.
  ///
  /// The [context] parameter is required and represents the build context.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: errorMessageNotifier,
      builder: (context, value, child) {
        return Visibility(
          visible: value.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
          ),
        );
      },
    );
  }
}