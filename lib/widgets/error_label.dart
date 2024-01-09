import 'package:flutter/material.dart';

class ErrorLabel extends StatelessWidget {
  const ErrorLabel({super.key, required this.errorMessageNotifier});

  final ValueNotifier<String> errorMessageNotifier;

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